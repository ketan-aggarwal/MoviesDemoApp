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
    func saveMoviesToCoreData(movies:[Movie])
    func fetchMoviesFromCoreData(completion: @escaping ([Movie]?) -> Void)
}

class MovieListWorker: MovieListWorkingLogic {
    
    func saveMoviesToCoreData(movies: [Movie]) {
        let context = CoreDataStack.shared.managedObjectContext
        do {
            try context.performAndWait {
                // Fetch existing movie entities with the given IDs
                let existingMoviesFetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                let existingMoviesIDs = movies.compactMap { $0.id }

                existingMoviesFetchRequest.predicate = NSPredicate(format: "id IN %@", existingMoviesIDs)
                let existingMovies = try context.fetch(existingMoviesFetchRequest)

                // Create a dictionary for faster lookup
                let existingMoviesDictionary = Dictionary(uniqueKeysWithValues: existingMovies.map { ($0.id, $0) })

                // Update or insert the movies into Core Data
                for movie in movies {
                    if let existingMovie = existingMoviesDictionary[movie.id!] {
                        // Update existing movie entity
                        existingMovie.title = movie.title
                        existingMovie.overview = movie.overview
                        existingMovie.vote_average = movie.vote_average ?? 0.0
                        existingMovie.imageUrl = movie.poster_path
                    } else {
                        // Insert a new movie entity
                        let movieEntity = MovieEntity(context: context)
                        movieEntity.id = Int64(movie.id!)
                        movieEntity.title = movie.title
                        movieEntity.overview = movie.overview
                        movieEntity.vote_average = movie.vote_average ?? 0.0
                        movieEntity.imageUrl = movie.poster_path
                    }
                }

                // Save the context
                CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Error saving movies to Core Data: \(error)")
        }
    }

        func fetchMoviesFromCoreData(completion: @escaping ([Movie]?) -> Void) {
            let context = CoreDataStack.shared.managedObjectContext
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()

            do {
                let movieEntities = try context.fetch(fetchRequest)
                let movies = movieEntities.map { Movie(
                    title: $0.title,
                    overview: $0.overview,
                    vote_average: $0.vote_average,
                    poster_path: $0.imageUrl,
                    id: Int64($0.id)
                ) }
                completion(movies)
            } catch {
                print("Error fetching movies from Core Data: \(error)")
                completion(nil)
            }
        }

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

