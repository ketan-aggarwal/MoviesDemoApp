////
////  MovieDetailsViewController.swift
////  MoviesList
////
////  Created by Ketan Aggarwal on 26/10/23.
////
//
//import UIKit
//import youtube_ios_player_helper
//
//
//class MovieDetailsViewController: UIViewController, YTPlayerViewDelegate {
//    
//    var movie: Movie?
//    var configuration:ImageConfiguration?
//    var trailers: [MovieTrailer] = []
//    var additionalInfo: MovieInfo?
//    var playerView:YTPlayerView!
//    var isLiked = false
// 
//    @IBAction func likedBtn(_ sender: Any) {
//        isLiked.toggle()
//        UserDefaults.standard.set(isLiked, forKey: "isLiked_\(movie?.id ?? 0)")
//        updateLikeButtonAppearance()
//        
//        
//    }
//    
//    @IBAction func eyeBtnTapped(_ sender: Any) {
//        
//        guard let movieTitle = movie?.overview else {
//            return
//        }
//        
//        let alert = UIAlertController(title: "Description\n", message: "", preferredStyle: .alert)
//        
//        let messageFont = UIFont(name: "Arial", size: 18) ?? UIFont.systemFont(ofSize: 18)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        
//        let attributedMessage = NSAttributedString(
//            string: movieTitle,
//            attributes: [
//                NSAttributedString.Key.font: messageFont,
//                NSAttributedString.Key.paragraphStyle: paragraphStyle
//            ]
//        )
//        
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        
//        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(dismissAction)
//        
//        
//        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
//            self.present(alert, animated: true, completion: nil)
//            
//        }
//        
//        // Add an animation effect (optional)
//        animator.addAnimations {
//            // Add any animations you want, such as scaling or fading
//            // For example, you can scale the alert to make it the focus
//            alert.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        }
//        
//        animator.startAnimation()
//    }
//    
//    func updateLikeButtonAppearance() {
//        if isLiked {
//            img.image = UIImage(systemName: "heart.fill")
//            likeBtn.tintColor = .red
//            
//        } else {
//            img.image = UIImage(systemName: "heart")
//            likeBtn.tintColor = .red
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        titleImg.image = UIImage(systemName: "eye")
//        eyeBtn.tintColor = .black
//        isLiked = UserDefaults.standard.bool(forKey: "isLiked_\(movie?.id ?? 0)")
//        
//        playerView = YTPlayerView()
//        playerView.delegate = self
//        
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(playerView)
//        let topConstraint = NSLayoutConstraint(item: playerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 60)
//        
//        let leadingConstraint = NSLayoutConstraint(item: playerView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
//        
//        let trailingConstraint = NSLayoutConstraint(item: playerView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
//        
//        let heightConstraint = NSLayoutConstraint(item: playerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
//        
//        NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,heightConstraint])
//        
//        fetchTrailerData()
//        fetchInfo()
//        updateLikeButtonAppearance()
//        
//        if let movie = movie{
//            FullTitle.text = movie.title
//        }else{
//            FullTitle.text = "Error fetching"
//        }
//    }
//    
//    func fetchTrailerData() {
//        if let movie = movie, let movieId = movie.id {
//            let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
//            MovieService.fetchMovieTrailers(movieID: movieId, apiKey: apiKey) { [weak self] trailers in
//                guard let self = self, let trailers = trailers else { return }
//                self.trailers = trailers
//                self.playTrailer(at: 0)
//            }
//        }
//    }
//    
//    func fetchInfo() {
//        guard let movie = movie, let movieId = movie.id else { return }
//        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
//        
//        MovieService.fetchAdditionalMovieInfo(movieID: movieId, apiKey: apiKey) { [weak self] movieInfo in
//            self?.additionalInfo = movieInfo
//            if let revenue = movieInfo?.revenue , let runtime = movieInfo?.runtime, let tagline = movieInfo?.tagline, let release_date = movieInfo?.release_date, let production_countries = movieInfo?.production_countries!, let spoken_lannguages = movieInfo?.spoken_languages!{
//                DispatchQueue.main.async {
//                    self?.revLabel.text = "$\(revenue/1000000) Mil."
//                    self?.runLabel.text = "\(runtime) Min."
//                    self?.tagLabel.text = "# \(tagline)"
//                    self?.releaseLabel.text = "\(release_date)"
//                    let countryNames = production_countries.map { $0.name! }.joined(separator: ", ")
//                    self?.countryLabel.text = countryNames
//                    let languages = spoken_lannguages.map {$0.english_name
//                    }.joined(separator: ", ")
//                    self?.langLabel.text = languages
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self?.revLabel.text = "Revenue data not available"
//                    self?.runLabel.text = "Runtime not available"
//                    self?.countryLabel.text = "India"
//                }
//            }
//        }
//    }
//    
//    func playTrailer(at index: Int) {
//        if let trailer = trailers.first ,let key = trailer.key {
//            print("YouTube Video ID: \(key)")
//            DispatchQueue.main.async { [weak self] in
//                self?.playerView.load(withVideoId: key)
//            }
//        } else {
//            print("Invalid trailer key")
//        }
//    }
//    
//}
//extension String {
//    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(
//            with: constraintRect,
//            options: [.usesLineFragmentOrigin, .usesFontLeading],
//            attributes: [NSAttributedString.Key.font: font],
//            context: nil
//        )
//        
//        return ceil(boundingBox.height)
//    }
//}
//
//
//
//
//
