//
//  MovieDetailModel.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import Foundation


//MovieInfo
struct ProductionCountry: Codable {
    let iso_3166_1: String?
    let name: String?
}

struct SpokenLanguage: Codable {
    let english_name: String
    let iso_639_1: String
    let name: String
}

struct MovieInfo: Codable {
    let spoken_languages: [SpokenLanguage]?
    let production_countries: [ProductionCountry]?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let release_date: String?
    var isLiked: Bool?

}

//Trailers
struct MovieTrailer:Codable{
    let name: String?
    let key: String?
}

struct MovieTrailersResponse: Codable {
    let results: [MovieTrailer]
}

//Request and Response Model

enum MovieDetailModel {
    enum FetchInfo {
        struct Request {
            let apiKey: String
            let movieID: Int?
        }
        struct Response {
            let movieInfo : MovieInfo
        }
    }
    
    enum FetchTrailer {
        struct Request {
            let apiKey: String
            let movieID: Int?
        }
        struct Response {
            let trailer: [MovieTrailer]
        }
    }
}
 
