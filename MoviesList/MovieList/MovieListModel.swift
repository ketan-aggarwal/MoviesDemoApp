//
//  MovieListModel.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//


import Foundation

// Data Models
struct Movie: Codable {
    let title: String?
    let overview: String?
    let vote_average: Double?
    let poster_path: String?
    let id: Int64?
}

struct MovieResponse: Codable {
    let results: [Movie]
}

struct ImageConfiguration: Codable {
    let base_url: String
    let secure_base_url: String
    let poster_sizes: [String]
}

struct Images: Codable {
    let images: ImageConfiguration
}

// Request and Response Models
enum MovieListModels {
    enum FetchMovies {
        struct Request {
            let apiKey: String
            let page: Int
            
        }

        struct Response {
            let movies: [Movie]
        }
    }

   

    enum FetchImageConfiguration {
        struct Request {
            let apiKey: String
        }

        struct Response {
            let imageConfig: ImageConfiguration
        }
    }
}

