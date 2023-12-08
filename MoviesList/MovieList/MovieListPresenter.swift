//
//  MovieListPresenter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//

import Foundation

protocol MoviePresentationLogic{
    func presentFetchMovies(response: MovieListModels.FetchMovies.Response)
    func presentFetchedConfiguration(response: MovieListModels.FetchImageConfiguration.Response)
}

class MoviePresenter: MoviePresentationLogic {
   
    weak var viewController: MovieDisplayLogic?
       
       func presentFetchMovies(response: MovieListModels.FetchMovies.Response) {
           let viewModel = MovieListViewModels.MovieListViewModel(movies: response.movies)
           viewController?.displayMovies(viewModel: viewModel)
       }
       
       func presentFetchedConfiguration(response: MovieListModels.FetchImageConfiguration.Response) {
           let viewModel = MovieListViewModels.ImageConfigurationViewModel(imageConfig: response.imageConfig)
           viewController?.displayConfiguration(viewModel: viewModel)
       }
    
    
}
