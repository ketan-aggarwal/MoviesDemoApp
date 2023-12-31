//
//  MovieDetailWorker.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import Foundation
import youtube_ios_player_helper
import CoreData

protocol MovieDetailWorkingLogic {
    func fetchMovieInfo(movieID: Int, apiKey: String , completion : @escaping (MovieInfo?) -> Void)
    func fetchTrailer(movieID: Int, apiKey: String , completion : @escaping ([MovieTrailer]?) -> Void)
    func saveMovieInfoToCoreData(movieID:Int, movieInfo: MovieInfo, isLiked: Bool)
    func fetchMovieInfoFromCoreData(movieID: Int, completion: @escaping (MovieInfoEntity?) -> Void)
}

class MovieDetailWorker: MovieDetailWorkingLogic {
   
    
    func saveMovieInfoToCoreData(movieID: Int,movieInfo: MovieInfo, isLiked: Bool) {
                let context = CoreDataStack.shared.managedObjectContext
                let fetchRequest: NSFetchRequest<MovieInfoEntity> = MovieInfoEntity.fetchRequest()
//                let id = movieID
//                print("movieid\(id)")
//                let uniqueIdentifier = "\(movieInfo.runtime ?? 0)_\(movieInfo.revenue ?? 0)_\(movieInfo.release_date ?? "")"
//                fetchRequest.predicate = NSPredicate(format: "uniqueIdentifier == %@", uniqueIdentifier)
                fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
 
                do {
                    let existingEntities = try context.fetch(fetchRequest)
                    if let existingEntity = existingEntities.first {
                        // Update existing entity
                        existingEntity.isLiked = isLiked
                        print("status movie:\(existingEntity.isLiked)")
                        existingEntity.languages = movieInfo.spoken_languages?.first?.english_name
                        existingEntity.productionCountries = movieInfo.production_countries?.first?.name
                        existingEntity.runtime = Int64(movieInfo.runtime ?? 0)
                        existingEntity.revenue = Int64(movieInfo.revenue ?? 0)
                        existingEntity.tagline = movieInfo.tagline
                        existingEntity.releaseDate = movieInfo.release_date

                        print("MovieInfo fetched from CoreData")
                    } else {
                        // Create new entity if it doesn't exist
                        let movieInfoEntity = MovieInfoEntity(context: context)
                        //movieInfoEntity.uniqueIdentifier = uniqueIdentifier
                        movieInfoEntity.id = Int64(movieID)
                        movieInfoEntity.languages = movieInfo.spoken_languages?.first?.english_name
                        movieInfoEntity.productionCountries = movieInfo.production_countries?.first?.name
                        movieInfoEntity.runtime = Int64(movieInfo.runtime ?? 0)
                        movieInfoEntity.revenue = Int64(movieInfo.revenue ?? 0)
                        movieInfoEntity.tagline = movieInfo.tagline
                        movieInfoEntity.releaseDate = movieInfo.release_date
                        movieInfoEntity.isLiked = isLiked

                        print("New MovieInfo saved to CoreData")
                    }

                    try context.save()
                } catch {
                    print("Error saving MovieInfo to CoreData: \(error.localizedDescription)")
                }
            }
     
        
        func fetchMovieInfoFromCoreData(movieID: Int, completion: @escaping (MovieInfoEntity?) -> Void) {
        let context = CoreDataStack.shared.managedObjectContext
        let fetchRequest: NSFetchRequest<MovieInfoEntity> = MovieInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let movieInfoEntities = try context.fetch(fetchRequest)
            if let movieInfoEntity = movieInfoEntities.first {
                completion(movieInfoEntity)
            } else {
                completion(nil)
            }
        } catch {
            print("Error fetching MovieInfoEntity from CoreData: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    
    func fetchMovieInfo(movieID: Int, apiKey: String, completion: @escaping (MovieInfo?) -> Void) {
        print("abcd:\(movieID)")
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&append_to_response=videos")!
        print("\(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async{
                if let error = error {
                    print("Error fetching additional movie data: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received when fetching additional movie data.")
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let movieInfo = try decoder.decode(MovieInfo.self, from: data)
                    completion(movieInfo)
                } catch {
                    print("Error decoding additional movie data: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchTrailer(movieID: Int, apiKey: String, completion: @escaping ([MovieTrailer]?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")!
        print(url)
        let task = URLSession.shared.dataTask(with: url)  { (data,response,error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("Error fetching movie trailers data: \(error)")
                    completion(nil)
                    return
                }
                guard let data = data else {
                    print("No data received when fetching movie trailers.")
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let trailersResponse = try decoder.decode(MovieTrailersResponse.self, from: data)
                    completion(trailersResponse.results)
                } catch {
                    print("Error decoding movie trailers data: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
}
