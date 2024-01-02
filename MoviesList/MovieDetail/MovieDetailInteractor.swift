import Foundation

protocol MovieDetailBusinessLogic {
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request)
    func fetchTrailer(request: MovieDetailModel.FetchInfo.Request)
    func updateLikedState(movieID: Int, isLiked: Bool)
    func fetchMovieInfoFromNetwork(movieID: Int)
    func getCurrentLikedState() -> Bool
}



class MovieDetailInteractor: MovieDetailBusinessLogic {
    
    
    var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    var movieID: Int = 0
    var trailer: [MovieTrailer]?
    var movieInfo: MovieInfo?
    var selectedMovie: Movie?
    var worker: MovieDetailWorkingLogic?
    var presenter: MovieDetailPresentationLogic
    var dataStore: MovieDetailDataStore
    
    
    init(worker: MovieDetailWorkingLogic, presenter:MovieDetailPresentationLogic, dataStore: MovieDetailDataStore) {
        self.worker = worker
        self.presenter = presenter
        self.dataStore = dataStore
        self.selectedMovie = dataStore.selectedMovie
    }
    

    func getCurrentLikedState() -> Bool {
        print("Selected Movie: \(selectedMovie)")
        print("Is Liked: \(selectedMovie?.isLiked)")
        
        return selectedMovie?.isLiked ?? false
    }

    
    func updateLikedState(movieID: Int, isLiked: Bool) {
        if movieInfo == nil {
                fetchMovieInfoFromNetwork(movieID: movieID)
                return
            }

            // Update isLiked state
            selectedMovie?.isLiked = isLiked
            presenter.presentLikedStateChange(isLiked: isLiked)

            // Save to CoreData
            worker?.saveMovieInfoToCoreData(movieID: movieID, movieInfo: movieInfo!, isLiked: isLiked)
        }
    
    
    
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request) {
        guard let movieID = self.selectedMovie?.id else {
            print("Selected Movie id is Nil")
            return
        }
        
        worker?.fetchMovieInfoFromCoreData(movieID: Int(movieID)) { movieInfoEntity in
            if let movieInfoEntity = movieInfoEntity {
                // Convert MovieInfoEntity to MovieInfo
                let movieInfo = MovieInfo(
                    spokenLanguages: movieInfoEntity.languages?.map { language in
                        SpokenLanguage(
                            englishName: movieInfoEntity.languages ?? "N/A" ,
                            iso6391: "",
                            name: ""
                        )
                    },
                    productionCountries: movieInfoEntity.productionCountries?.map { country in
                        ProductionCountry(
                            iso31661: "",
                            name: movieInfoEntity.productionCountries
                        )
                    },
                    revenue: Int(movieInfoEntity.revenue),
                    runtime: Int(movieInfoEntity.runtime),
                    tagline: movieInfoEntity.tagline ?? "",
                    releaseDate: movieInfoEntity.releaseDate ?? "",
                    isLiked: movieInfoEntity.isLiked
                )
                self.movieInfo = movieInfo
                let response = MovieDetailModel.FetchInfo.Response(movieInfo: movieInfo)
                self.presenter.presentFetchInfo(response: response)
                self.presenter.presentLikedStateChange(isLiked: movieInfo.isLiked!)
                
            } else {
                // Fetch from network if not available in CoreData
                self.fetchMovieInfoFromNetwork(movieID: Int(movieID))
                
            }
            
        }
    }
        


    
    func fetchMovieInfoFromNetwork(movieID: Int) {
        worker?.fetchMovieInfo(movieID: movieID, apiKey: apiKey) { [weak self] movieInfo in
            // Retain the current liked state
            let currentLikedState = self?.getCurrentLikedState() ?? false

            // Update the movieInfo with the current liked state
            self?.movieInfo = movieInfo
            self?.movieInfo?.isLiked = currentLikedState

            if let movieInfo = movieInfo {
                // Save to CoreData
                self?.worker?.saveMovieInfoToCoreData(movieID: movieID, movieInfo: movieInfo, isLiked: currentLikedState)

                // Present the fetched data
                let response = MovieDetailModel.FetchInfo.Response(movieInfo: movieInfo)
                self?.presenter.presentFetchInfo(response: response)
                self?.presenter.presentLikedStateChange(isLiked: currentLikedState)
            }
        }
    }
  
    
        func fetchTrailer(request: MovieDetailModel.FetchInfo.Request) {
            guard let movieID = self.selectedMovie?.id else {
                return
            }
    
            worker?.fetchTrailer(movieID: Int(movieID), apiKey: apiKey) { [weak self] trailers in
                self?.trailer = trailers
                if let trailers = trailers {
                    let response = MovieDetailModel.FetchTrailer.Response(trailer: trailers)
                    self?.presenter.presentTrailer(response: response)
                }
    
            }
        }
    
}
