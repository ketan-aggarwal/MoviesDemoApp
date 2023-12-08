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
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var FullTitle: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var eyeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPlayer()
        updateLikeButtonAppearance()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        eyeImg.image = UIImage(systemName: "eye")
        eyeImg.tintColor = .white
        let movieID =  (dataStore?.selectedMovie?.id ?? 0)
        let request = MovieDetailModel.FetchInfo.Request(apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6", movieID: Int(movieID))
        interactor?.fetchMovieInfo(request: request)
        interactor?.fetchTrailer(request: request)
        detailTable.rowHeight = UITableView.automaticDimension
        detailTable.separatorStyle = .none
    }
    
    @IBAction func descBtn(_ sender: Any) {
        guard let overview = dataStore?.selectedMovie?.overview else {
            return
        }
        let alert = UIAlertController(title: "Description\n", message: "", preferredStyle: .alert)
        let messageFont = UIFont(name: "Arial", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedMessage = NSAttributedString(
            string: overview,
            attributes: [
                NSAttributedString.Key.font: messageFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.present(alert, animated: true, completion: nil)
        }
        animator.addAnimations {
            alert.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        animator.startAnimation()
    }
    
    func updateLikedState(isLiked: Bool) {
            // Implement your logic to update the UI based on the 'isLiked' state
            // For example, you might want to update the appearance of your like button.
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
        tagLabel.text = "# \(viewModel.movieInfo.tagline ?? "No TagLine")"
        values = [
            viewModel.movieInfo.spoken_languages?.first?.english_name ?? "N/A",
            "\((viewModel.movieInfo.revenue).map{ String($0/1000000) } ?? "Nil") Mil.",
            "\((viewModel.movieInfo.runtime).map{ String($0) } ?? "Nil") Min.",
            viewModel.movieInfo.release_date,
            viewModel.movieInfo.production_countries?.first?.name ?? "N/A",
        ]
        
        DispatchQueue.main.async {
            self.detailTable.reloadData()
        }
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
            

           //startMarqueeAnimation()
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
        //stopMarqueeAnimation()
    }
}



