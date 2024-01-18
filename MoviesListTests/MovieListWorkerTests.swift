//
//  MovieListWorkerTests.swift
//  MoviesListTests
//
//  Created by Ketan Aggarwal on 19/12/23.
//

import XCTest
@testable import MoviesList

final class MovieListWorkerTests: XCTestCase {

    var movieListWorker: MovieListWorkingLogic!
    
    override func setUp(){
        super.setUp()
        movieListWorker = MovieListWorker()
    }
    override func tearDown() {
           movieListWorker = nil
           super.tearDown()
       }
    
    func testFetchMovies() {
            // Given
            let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
            let currentPage = 1
            let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(currentPage)"

            let expectation = self.expectation(description: "Movies should be fetched")

            // When
            movieListWorker.fetchMovies(apiKey: apiKey, currentPage: currentPage, url: url) { movies in
                // Then
                XCTAssertNotNil(movies, "Movies should not be nil")
                XCTAssertTrue(!movies!.isEmpty, "Movies array should not be empty")
                print("hi ketan")
                expectation.fulfill()
            }

            // Wait for the expectation to be fulfilled, or timeout after a specified time
            waitForExpectations(timeout: 10, handler: nil)
        }
    
    func testFetchConfiguration() {
            // Given
            let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6" // Replace with your actual API key
            let expectation = self.expectation(description: "Configuration should be fetched")

            // When
            movieListWorker.fetchConfiguration(apiKey: apiKey) { configuration in
                // Then
                XCTAssertNotNil(configuration, "Configuration should not be nil")
                expectation.fulfill()
            }

            // Wait for the expectation to be fulfilled, or timeout after a specified time
            waitForExpectations(timeout: 10, handler: nil)
        }
}
