//
//  MovieDetailDataStore.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 28/11/23.
//

import Foundation

protocol MovieDetailDataStore{
    func setupDataStore(_ movie: Movie, apiKey: String)
    var apiKey: String { get set }
    var selectedMovie: Movie? {get set}
    
}
class MovieDetailDataStoreImp: MovieDetailDataStore {
   
    
    var apiKey: String = ""
    var selectedMovie: Movie?
    
    func setupDataStore(_ movie: Movie, apiKey: String) {
        self.selectedMovie = movie
        self.apiKey = apiKey
    }
}
