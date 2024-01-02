//
//  MovieDetailWorkerTests.swift
//  MoviesListTests
//
//  Created by Ketan Aggarwal on 19/12/23.
//

import XCTest
@testable import MoviesList

final class MovieDetailWorkerTests: XCTestCase {

    var movieDetailWorker:  MovieDetailWorker!
    
    override func setUp(){
        super.setUp()
        movieDetailWorker = MovieDetailWorker() 
    }
    
    override func tearDown() {
        movieDetailWorker = nil
           super.tearDown()
       }
   
    
    func testFetchInfo(){
        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
        let movieId = 565770
        
        let expectation = self.expectation(description: "Movie Info should be fetched")
        movieDetailWorker.fetchMovieInfo(movieID: movieId, apiKey: apiKey){ movieInfo in
            print(movieInfo?.releaseDate!)
            XCTAssertNotNil(movieInfo, "Additional info should be fetched")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTrailers(){
        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
        let movieId = 565770
        let expectation = self.expectation(description: "Trailer should be fetched")
        
        movieDetailWorker.fetchTrailer(movieID: movieId, apiKey: apiKey){ trailer in
            
            XCTAssertNotNil(trailer, "Trailer should be fetched")
            print(trailer?.first?.name)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
//    func testNilMovieInfo(){
//        var worker = MockMovieDetailWorker()
//
//        worker.fetchMovieInfo(movieID: 0, apiKey: "abc") { movie in
//            XCTAssertNil(movie)
//        }
//    }
}

//class MockMovieDetailWorker: MovieDetailWorkingLogic {
//    func fetchMovieInfo(movieID: Int, apiKey: String, completion: @escaping (MoviesList.MovieInfo?) -> Void) {
//        var movieInfo = MovieInfo()
//        // movieInfo.revenue = 40
//        //fetch file content , file should be json
//        completion(movieInfo)
//    }
//
//    func fetchTrailer(movieID: Int, apiKey: String, completion: @escaping ([MoviesList.MovieTrailer]?) -> Void) {
//
//    }
//
//    func saveMovieInfoToCoreData(movieID: Int, movieInfo: MoviesList.MovieInfo, isLiked: Bool) {
//
//    }
//
//    func fetchMovieInfoFromCoreData(movieID: Int, completion: @escaping (MoviesList.MovieInfoEntity?) -> Void) {
//
//    }
//
//    }
//extension MovieInfo {
//    init(){
//        self.init()
//    }
//}


