////
////  ViewController.swift
////  MoviesList
////
////  Created by Ketan Aggarwal on 26/10/23.
////
//
//import UIKit
//import SDWebImage
//import CoreData
//
//
//class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
//    @IBOutlet weak var myTable: UITableView!
//    
////    var configuration: ImageConfiguration?
////    var movies: [Movie] = []
////    var movieInfoArray: [MovieInfo?] = []
////    var movie: Movie?
////    var currentPage = 1
////    let button = UIButton()
////    let coreDataStack = CoreDataStack.shared
////
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        myTable.separatorStyle = UITableViewCell.SeparatorStyle.none
//        //setupButton()
//        
//        setupTableView()
////        fectchConfig()
////        fetchMovieData()
//    }
//    

//    



//    
//    

//    
//    


//    
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return movies.count
////    }
//    
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
////        cell.selectionStyle = .none
////        let movie = movies[indexPath.row]
////
////
////
////        cell.title?.text = movie.title
////        cell.desc?.text = movie.overview
////        cell.rating?.text = String(movie.vote_average!)
////
////
////
////        if let configuration = configuration, let posterPath = movie.poster_path {
////            print("inside if statement")
////            DispatchQueue.main.async {
////                print("inside dispatch")
////                if let fullPosterURL = URL(string: configuration.base_url)?
////                    .appendingPathComponent(configuration.poster_sizes[5])
////                    .appendingPathComponent(posterPath) {
////                    print(fullPosterURL)
////                    cell.img.sd_setImage(with: fullPosterURL, placeholderImage: UIImage(named: "placeholderImage"))
////                }
////            }
////
////        }
////        return cell
////    }
//    
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
////
////        let movie = movies[indexPath.row]
////        vc.movie = movie
////        self.navigationController?.pushViewController(vc, animated: true)
////
////    }
//    
//  
//}
//
//
