//
//  MovieListRouter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 21/11/23.
//

import Foundation
import UIKit

protocol MovieListRoutingLogic {
    func navigateToMovieDetail(movie: Movie)
}

protocol MovieListDataPassing {
    var dataStore: MovieListDataStore? { get set}
    func passMovieData(_ movie: Movie)
}

class MovieListRouter: MovieListRoutingLogic, MovieListDataPassing {

    weak var viewController: MovieViewController?
    var dataStore: MovieListDataStore?
    
    init(viewController: MovieViewController) {
        self.viewController = viewController
    }
    
    func navigateToMovieDetail(movie: Movie) {
                if let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                    
                    let dataStore = MovieDetailDataStoreImp()
                    dataStore.setupDataStore(movie, apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6")
                    let router = MovieDetailRouter(viewController: movieDetailViewController, dataStore: dataStore)
                    movieDetailViewController.dataStore = MovieDetailDataStoreImp()
                    movieDetailViewController.dataStore?.selectedMovie = movie
                    movieDetailViewController.router = router
                    
                    viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
                }
    }
    
    func passMovieData(_ movie: Movie) {
        dataStore?.selectedMovie = movie
       
        }
}
        
        
        
        
    


