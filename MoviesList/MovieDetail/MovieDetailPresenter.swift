//
//  MovieDetailPresenter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import Foundation

protocol MovieDetailPresentationLogic {
    func presentFetchInfo(response: MovieDetailModel.FetchInfo.Response)
    func presentTrailer(response: MovieDetailModel.FetchTrailer.Response)
    func presentLikedStateChange(isLiked: Bool)
}

class MovieDetailPresenter:MovieDetailPresentationLogic {
    
    var movieDetailViewController: MovieDetailDisplayLogic?
    
    func presentFetchInfo(response: MovieDetailModel.FetchInfo.Response) {
        let viewModel = MovieDetailViewModels.MovieInfoViewModel(movieInfo: response.movieInfo)
        movieDetailViewController?.displayMovieInfo(viewModel: viewModel)
    }
    
    func presentTrailer(response: MovieDetailModel.FetchTrailer.Response) {
        let viewModel = MovieDetailViewModels.MovieTrailerViewModel(trailers: response.trailer)
        movieDetailViewController?.displayTrailer(viewModel: viewModel)
    }
    
    func presentLikedStateChange(isLiked: Bool) {
            movieDetailViewController?.updateLikedState(isLiked: isLiked)
        }
}
