//
//  MovieDetailModel.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import Foundation


//MovieInfo
//struct ProductionCountry: Codable {
//    let iso_3166_1: String?
//    let name: String?
//}
//
//struct SpokenLanguage: Codable {
//    let english_name: String
//    let iso_639_1: String
//    let name: String
//}
//
//struct MovieInfo: Codable {
//    let spoken_languages: [SpokenLanguage]?
//    let production_countries: [ProductionCountry]?
//    let revenue: Int?
//    let runtime: Int?
//    let tagline: String?
//    let release_date: String?
//    var isLiked: Bool?
//
//}

enum ProductionCountryCodingKeys: String, CodingKey {
    case iso31661 = "iso_3166_1"
    case name
}

struct ProductionCountry: Codable {
    let iso31661: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
            case iso31661 = "iso_3166_1"
            case name
        }
}

enum SpokenLanguageCodingKeys: String, CodingKey {
    case englishName = "english_name"
    case iso6391 = "iso_639_1"
    case name
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
           case englishName = "english_name"
           case iso6391 = "iso_639_1"
           case name
       }

}

enum MovieInfoCodingKeys: String, CodingKey {
    case spokenLanguages = "spoken_languages"
    case productionCountries = "production_countries"
    case revenue
    case runtime
    case tagline
    case releaseDate = "release_date"
    case isLiked
}

struct MovieInfo: Codable {
    let spokenLanguages: [SpokenLanguage]?
    let productionCountries: [ProductionCountry]?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let releaseDate: String?
    var isLiked: Bool?
 
    enum CodingKeys: String, CodingKey {
        case spokenLanguages = "spoken_languages"
        case productionCountries = "production_countries"
        case revenue
        case runtime
        case tagline
        case releaseDate = "release_date"
        case isLiked
    }
   
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
 
