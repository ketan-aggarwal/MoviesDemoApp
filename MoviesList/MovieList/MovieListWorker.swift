//
//  MovieListWorker.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//

import Foundation
import CoreData

protocol MovieListWorkingLogic {
    func fetchMovies(apiKey:String, currentPage:Int, url: String,completion: @escaping ([Movie]?)->Void)
    func fetchConfiguration(apiKey:String, completion: @escaping (ImageConfiguration?)->Void)

}

class MovieListWorker: MovieListWorkingLogic {

    

    func fetchMovies(apiKey: String, currentPage: Int,url: String, completion: @escaping ([Movie]?) -> Void) {
        let url = URL(string:url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let movieResonse = try decoder.decode(MovieResponse.self, from: data)
                        let movies = movieResonse.results
                    
                        completion(movies)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                } else if let error = error {
                    print("Error fetching data: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    func fetchConfiguration(apiKey: String, completion: @escaping (ImageConfiguration?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/configuration?api_key=\(apiKey)")!
        print("aggarwal\(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error while fetching Configuration details: \(error)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received for Configuration details")
                    completion(nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let configuration = try decoder.decode(Images.self, from: data)
                    completion(configuration.images)
                } catch {
                    print("Error while decoding JSON for Configuration details: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

