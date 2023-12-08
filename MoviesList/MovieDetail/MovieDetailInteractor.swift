import Foundation

protocol MovieDetailBusinessLogic {
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request)
    func fetchTrailer(request: MovieDetailModel.FetchInfo.Request)
    func updateLikedState(movieID: Int, isLiked: Bool)
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
    
//    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request) {
//        guard let movieID = self.selectedMovie?.id else {
//            print("hello \(movieID)")
//            return
//        }
//        worker?.fetchMovieInfo(movieID: Int(movieID), apiKey: apiKey) { [weak self] movieInfo in
//            self?.movieInfo = movieInfo
//             //movieInfo.title = selectedMovieTitle
//
//            if let movieInfo = movieInfo {
//                let response = MovieDetailModel.FetchInfo.Response(movieInfo: movieInfo)
//                self?.presenter.presentFetchInfo(response: response)
//            }
//        }
//    }
    func updateLikedState(movieID: Int, isLiked: Bool) {
        worker?.saveMovieInfoToCoreData(movieID: movieID,movieInfo: movieInfo!, isLiked: isLiked)
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
                            spoken_languages: movieInfoEntity.languages?.map { language in
                                SpokenLanguage(
                                    english_name: movieInfoEntity.languages ?? "N/A" ,
                                    iso_639_1: "",
                                    name: ""
                                )
                            },
                            production_countries: movieInfoEntity.productionCountries?.map { country in
                                ProductionCountry(
                                    iso_3166_1: "",
                                    name: movieInfoEntity.productionCountries
                            )
                            },
                            revenue: Int(movieInfoEntity.revenue),
                            runtime: Int(movieInfoEntity.runtime),
                            tagline: movieInfoEntity.tagline ?? "",
                            release_date: movieInfoEntity.releaseDate ?? "",
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
                self?.movieInfo = movieInfo

                if let movieInfo = movieInfo {
                    // Save to CoreData
                    self?.worker?.saveMovieInfoToCoreData(movieID: movieID,movieInfo: movieInfo, isLiked: self?.movieInfo?.isLiked ?? false)

                    let response = MovieDetailModel.FetchInfo.Response(movieInfo: movieInfo)
                    self?.presenter.presentFetchInfo(response: response)
                   
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
