//
//  MovieListInteractor.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//

import Foundation


protocol MovieBusinessLogic {
    func fetchMovies(request: MovieListModels.FetchMovies.Request, url:String)
    func fetchConfiguration(request : MovieListModels.FetchImageConfiguration.Request)
    func incrementCurrentPage() -> Int

    
}

protocol MovieListDataStore {
    var apiKey: String {get set}
    var currentPage: Int {get set}
   
    var movies : [Movie]? {get set}
    var imageConfiguration: ImageConfiguration? {get set}
    var selectedMovie: Movie? {get set}
    func setMovieData(_ movie: Movie)
}

class MovieListInteractor: MovieBusinessLogic, MovieListDataStore {
    

    var selectedMovie: Movie?
    var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    var currentPage: Int = 1
    var movies: [Movie]?
    var imageConfiguration: ImageConfiguration?
    var movieID: Int?
    var worker: MovieListWorkingLogic
    var presenter: MoviePresentationLogic?
    
    
    
    init(worker: MovieListWorkingLogic = MovieListWorker(), presenter: MoviePresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }


    
    func fetchMovies(request: MovieListModels.FetchMovies.Request, url:String) {
        worker.fetchMovies(apiKey: apiKey, currentPage: currentPage, url: url) { [weak self] movies in
                guard let self = self else { return }
                self.movies = movies
                
           
                if let firstMovie = movies?.first {
                    self.selectedMovie = firstMovie
                    // Set the selected movie in the dataStore
                    self.setMovieData(firstMovie)
                    print("Selected Movie: \(String(describing: self.selectedMovie))")
                }

                let response = MovieListModels.FetchMovies.Response(movies: movies ?? [])
                self.presenter?.presentFetchMovies(response: response)
            }
        }
        
        func fetchConfiguration(request: MovieListModels.FetchImageConfiguration.Request) {
            worker.fetchConfiguration(apiKey: apiKey) { [weak self] configuration in
                guard let self = self else { return }
                
                if let configuration = configuration {
                    self.imageConfiguration = configuration
                    let response = MovieListModels.FetchImageConfiguration.Response(imageConfig: configuration)
                    self.presenter?.presentFetchedConfiguration(response: response)
                } else {
                    
                }
            }
        }
        
        
        
        func incrementCurrentPage() -> Int{
            currentPage += 1
            return currentPage
        }
        
        func setMovieData(_ movie: Movie) {
                // Set the selected movie in the dataStore
                selectedMovie = movie
            }
    
}
