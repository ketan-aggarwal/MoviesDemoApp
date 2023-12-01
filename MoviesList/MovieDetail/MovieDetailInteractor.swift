import Foundation

protocol MovieDetailBusinessLogic {
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request)
    func fetchTrailer(request: MovieDetailModel.FetchInfo.Request)
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
    
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request) {
        guard let movieID = self.selectedMovie?.id else {
            print("hello \(movieID)")
            return
        }
        
        worker?.fetchMovieInfo(movieID: Int(movieID), apiKey: apiKey) { [weak self] movieInfo in
            self?.movieInfo = movieInfo
             //movieInfo.title = selectedMovieTitle
               
            if let movieInfo = movieInfo {
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
