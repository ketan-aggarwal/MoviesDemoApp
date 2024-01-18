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


    
    func fetchMovies(request: MovieListModels.FetchMovies.Request, url: String) {
        worker.fetchMovies(apiKey: apiKey, currentPage: currentPage, url: url) { [weak self] newMovies in
            guard let self = self else { return }

            if let newMovies = newMovies {
                if self.currentPage == 1 {
                    // Replace the existing movies array with the new movies
                    self.movies = newMovies
                } else {
                    // Append the new movies to the existing array
                    self.movies?.append(contentsOf: newMovies)
                }

                if let firstMovie = newMovies.first {
                    self.selectedMovie = firstMovie
                    self.setMovieData(firstMovie)
                   
                }

                let response = MovieListModels.FetchMovies.Response(movies: newMovies)
                self.presenter?.presentFetchMovies(response: response)
            }
        }

    }
    
//
        
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
        
    func getUrlFor(posterPath: String?) -> URL?{
        if let configuration = imageConfiguration,
           let posterPath = posterPath,
           let fullPosterURL = URL(string: configuration.base_url)?
            .appendingPathComponent(configuration.poster_sizes[1])
            .appendingPathComponent(posterPath){
                    return fullPosterURL
        }
        return nil
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
