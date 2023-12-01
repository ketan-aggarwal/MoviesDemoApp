//
//  MovieViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//

import UIKit
import SDWebImage



protocol MovieDisplayLogic: AnyObject {
    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel)
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel)
}

class MovieViewController: UIViewController , MovieDisplayLogic, UITableViewDelegate, UITableViewDataSource, MovieListDataPassing{
    
    
    var dataStore: MovieListDataStore?
    
    @IBOutlet weak var myTable: UITableView!
    
    public var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    public var currentPage = 1
    var movies:[Movie]?
    var configuration : ImageConfiguration?
    var interactor: MovieListInteractor?
    var router: MovieListRouter?
   
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setup()
       setupButton()
       popularMoviesSelected()
        fetchConfiguration(apiKey: apiKey)
        //fetchMovies(apiKey: apiKey)
        configureBarBtn()
    }
    
    private func setup() {
        let viewController = self
        let presenter = MoviePresenter()
        let interactor = MovieListInteractor(presenter: presenter)
        let worker = MovieListWorker()
        let router = MovieListRouter(viewController: viewController)
        router.dataStore = interactor
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
    }
    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        
    }
    func setupButton(){
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = .systemBlue
        button.setTitle("Load More", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        myTable.tableFooterView = button
    }

    func configureBarBtn() {
        let optionsButton = UIButton(type: .system)
        optionsButton.setTitle("Filter", for: .normal)
        //optionsButton.setImage("Filter", for: .normal)
        optionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)

        let optionsBarButton = UIBarButtonItem(customView: optionsButton)
        navigationItem.rightBarButtonItem = optionsBarButton
    }

    @objc func showOptions(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)

        let popularAction = UIAlertAction(title: "Popular Movies", style: .default) { _ in
            self.popularMoviesSelected()
        }
        
        let upcomingAction = UIAlertAction(title: "Upcoming Movies", style: .default) { _ in
            self.upcomingMoviesSelected()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(popularAction)
        alertController.addAction(upcomingAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .up
        }

        present(alertController, animated: true, completion: nil)
    }

    @objc func popularMoviesSelected() {
        currentPage = 1
        navigationItem.title = "Popular Movies"
        let popuralUrl = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(currentPage)"
        fetchMovies(apiKey: apiKey,url: popuralUrl)
        print("Popular Movies selected")
       
       
    }

    @objc func upcomingMoviesSelected() {
        currentPage = 1
        navigationItem.title = "Upcoming Movies"
        let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(currentPage)"
        fetchMovies(apiKey: apiKey,url: upcomingUrl)
        
        
    }

    @objc func buttonTapped(){
        currentPage += 1
           let url: String
           if navigationItem.title == "Popular Movies" {
               url = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(currentPage)"
           } else {
               url = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(currentPage)"
           }

           
           fetchMovies(apiKey: apiKey, url: url)
    }
    
    func fetchMovies(apiKey: String,url:String){
        interactor!.fetchMovies(request: MovieListModels.FetchMovies.Request(apiKey: apiKey, page: 1),url: url)
    }
    
    func fetchConfiguration(apiKey: String){
        interactor!.fetchConfiguration(request: MovieListModels.FetchImageConfiguration.Request(apiKey: apiKey))
    }
    

    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel) {
        DispatchQueue.main.async {
            if self.currentPage == 1 {
                // Replace the existing movies array with the new movies
                self.movies = viewModel.movies
            } else {
                // Append the new movies to the existing array
                self.movies?.append(contentsOf: viewModel.movies)
            }
            self.myTable.reloadData()
        }
    }
    
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel) {
        configuration = viewModel.imageConfig
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        cell.selectionStyle = .none
        cell.title?.text = movie.title ?? "hello"
        cell.desc?.text = movie.overview
        cell.rating?.text = String(movie.vote_average!)
        
        if let configuration = configuration, let posterPath = movie.poster_path {
            
            DispatchQueue.main.async {
                if let fullPosterURL = URL(string: configuration.base_url)?
                    .appendingPathComponent(configuration.poster_sizes[5])
                    .appendingPathComponent(posterPath) {
                    //print(fullPosterURL)
                    cell.img.sd_setImage(with: fullPosterURL, placeholderImage: UIImage(named: "placeholderImage"))
                }
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = movies?[indexPath.row] {
            passMovieData(selectedMovie)
            
        }
       
    }
    
    func passMovieData(_ movie: Movie) {
        router?.navigateToMovieDetail(movie: movie)
    }
    
    
}
