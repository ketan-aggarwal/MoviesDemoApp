//
//  MovieDetailViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import UIKit
import youtube_ios_player_helper
import CoreData

protocol MovieDetailDisplayLogic {
    func displayMovieInfo(viewModel: MovieDetailViewModels.MovieInfoViewModel)
    func displayTrailer(viewModel: MovieDetailViewModels.MovieTrailerViewModel)
    func updateLikedState(isLiked: Bool)
}

class MovieDetailViewController: UIViewController , MovieDetailDisplayLogic, UITableViewDelegate, UITableViewDataSource,YTPlayerViewDelegate, CAAnimationDelegate{
    
    var dataStore: MovieDetailDataStoreImp?
    public var isLiked = false
    var playerView:YTPlayerView!
    var interactor: MovieDetailBusinessLogic?
    var movieID: Int?
    var router: MovieDetailRoutingLogic?
    var isDescriptionExpanded = false
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var FullTitle: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    //@IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
   // @IBOutlet weak var eyeImg: UIImageView!
    @IBOutlet weak var fullDesc: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var shareImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPlayer()
        updateLikeButtonAppearance()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let movieID =  (dataStore?.selectedMovie?.id ?? 0)
        let request = MovieDetailModel.FetchInfo.Request(apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6", movieID: Int(movieID))
        interactor?.fetchMovieInfo(request: request)
        interactor?.fetchTrailer(request: request)
        detailTable.rowHeight = UITableView.automaticDimension
        detailTable.separatorStyle = .none
        shareImg.image = UIImage(systemName: "square.and.arrow.up")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshBtn))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped))
               fullDesc.isUserInteractionEnabled = true
        fullDesc.addGestureRecognizer(tapGestureRecognizer)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
                doubleTapGesture.numberOfTapsRequired = 2
                view.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func doubleTapAction() {
           isLiked.toggle()
           updateLikeButtonAppearance()

           if let movieInfo = dataStore?.selectedMovie {
               interactor?.updateLikedState(movieID: Int(movieInfo.id!), isLiked: isLiked)
               updateLikeButtonAppearance()
           }
       }
    
    @objc func titleLabelTapped() {
           isDescriptionExpanded.toggle()
           updateDescriptionLabel()
       }
    
    func configUI(){
        FullTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        FullTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        FullTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

            // Set a minimum height for label1 (adjust as needed)
            let minHeightConstraint = FullTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
            minHeightConstraint.priority = UILayoutPriority(999) // Set a high priority for the minimum height constraint
            minHeightConstraint.isActive = true

        fullDesc.topAnchor.constraint(equalTo:FullTitle.bottomAnchor).isActive = true
        fullDesc.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fullDesc.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fullDesc.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

        detailTable.topAnchor.constraint(equalTo:  fullDesc.bottomAnchor).isActive = true
        detailTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    

    func updateDescriptionLabel() {
        guard let overview = dataStore?.selectedMovie?.overview else{
            return
        }
            if isDescriptionExpanded {
               fullDesc.numberOfLines = 0
            } else {
                fullDesc.numberOfLines = 2
            }
        fullDesc.text = overview
        }
   

    @IBAction func shareMovie(_ sender: Any) {
        guard let movieID = dataStore?.selectedMovie?.id else {
            return
        }

        // Construct the deep link URL using your custom scheme
        if let deepLinkURL = createDeepLinkURL(movieID: Int(movieID)) {
            // Create an activity view controller to share the deep link
            let activityViewController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func updateLikedState(isLiked: Bool) {
            self.isLiked = isLiked
           print("helllolll\(isLiked)")
            updateLikeButtonAppearance()
        }
    
    @IBAction func likeBtn(_ sender: Any) {
         isLiked.toggle()
        updateLikeButtonAppearance()
        
        if var movieInfo = dataStore?.selectedMovie {
            movieInfo.isLiked = isLiked
            dataStore?.selectedMovie = movieInfo
            
            interactor?.updateLikedState(movieID: Int(movieInfo.id!), isLiked: isLiked)
            updateLikeButtonAppearance()
        }

    }

    func updateLikeButtonAppearance() {
        if isLiked {
            DispatchQueue.main.async {
                self.img.image = UIImage(systemName: "heart.fill")
                self.likeBtn.tintColor = .red
            }
            
        } else {
            DispatchQueue.main.async {
                self.img.image = UIImage(systemName: "heart")
                self.likeBtn.tintColor = .red
            }
           
        }
    }

    func setupPlayer(){
        playerView = YTPlayerView()
        playerView.delegate = self
        playerView.backgroundColor = .clear
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        let topConstraint = NSLayoutConstraint(item: playerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 90)
        let leadingConstraint = NSLayoutConstraint(item: playerView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: playerView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: playerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240)
        NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,heightConstraint])
    }
    
    private func setup() {
        let movieDetailviewController = self
        let presenter = MovieDetailPresenter()
        let worker = MovieDetailWorker()
        guard let router = router else{ return }
        let interactor = MovieDetailInteractor(worker: worker, presenter: presenter, dataStore: router.dataStore)
        movieDetailviewController.router = router
        movieDetailviewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.movieDetailViewController = movieDetailviewController
    }
    
    @objc func refreshBtn(_ sender: UIButton){
        let movieID = dataStore?.selectedMovie?.id ?? 0
            
            // Save the current liked state
            let currentLikedState = interactor?.getCurrentLikedState() ?? false
            print("current state \(currentLikedState)")
            
            // Fetch movie info and trailer from the network
            let request = MovieDetailModel.FetchInfo.Request(apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6", movieID: Int(movieID))
            interactor?.fetchTrailer(request: request)
            interactor?.fetchMovieInfoFromNetwork(movieID: Int(movieID))
            
            // Always update the liked state
            interactor?.updateLikedState(movieID: Int(movieID), isLiked: currentLikedState)
    }
    
    
    var labels: [String] = ["Languages:","Revenue:","Runtime:","Release Date:","Production Countries:"]
    var values: [String?] = [nil,nil,nil,nil,nil]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.selectionStyle = .none
        cell.titleLabel.text = labels[indexPath.row]
        cell.valueLabel.text = values[indexPath.row] ?? "N/A"
        return cell
    }
    
    func displayMovieInfo(viewModel: MovieDetailViewModels.MovieInfoViewModel) {
        FullTitle.text = dataStore?.selectedMovie?.title ?? "N/A"
        //FullTitle.text = viewModel.movieInfo.originalTitle
       // fullDesc.text = viewModel.movieInfo.overview
        updateDescriptionLabel()
        tagLabel.text = "\(viewModel.movieInfo.tagline ?? "No TagLine")"

        values = [
            viewModel.movieInfo.spokenLanguages?.first?.englishName ?? "N/A",
            "\((viewModel.movieInfo.revenue).map{ String($0/1000000) } ?? "Nil") Mil.",
            "\((viewModel.movieInfo.runtime).map{ String($0) } ?? "Nil") Min.",
            "\(viewModel.movieInfo.releaseDate ?? "N/A" )"  ,
            viewModel.movieInfo.productionCountries?.first?.name ?? "N/A",
        ]
        
        DispatchQueue.main.async {
            self.detailTable.reloadData()
        }
    }

 
    
    func createDeepLinkURL(movieID: Int) -> URL? {
        // Construct your deep link URL using the custom scheme and necessary parameters
        let deepLinkString = "moviesapp://movie?id=\(movieID)"
        return URL(string: deepLinkString)
    }
    
    func displayTrailer(viewModel: MovieDetailViewModels.MovieTrailerViewModel){
        DispatchQueue.main.async {
               ActivityIndicatorManager.shared.showActivityIndicator()
           }
        if let trailer = viewModel.trailers.first, let key = trailer.key {
            print("YouTube Video ID: \(key)")
           
                DispatchQueue.main.async { [weak self] in
                    self?.playerView.load(withVideoId: key)
                    
                }
        } else {
            print("Invalid trailer key")
        }
    }
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        DispatchQueue.main.async {
            ActivityIndicatorManager.shared.hideActivityIndicator()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
}



