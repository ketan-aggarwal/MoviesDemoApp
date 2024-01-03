//
//  SceneDelegate.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var deepLinkObserverAdded = false
    
    private (set) static var shared: SceneDelegate?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let  windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        SceneDelegate.shared = self
        handleRootVC()

    }
    
    func handleRootVC(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
                let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
                let navigationController = UINavigationController(rootViewController: movieViewController)
                window?.rootViewController = navigationController
            } else {
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navigationController = UINavigationController(rootViewController: loginViewController)
                window?.rootViewController = navigationController
            }

            window?.makeKeyAndVisible()
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                print("Deep link \(url)")
                NotificationCenter.default.post(
                    name: Notification.Name("DeepLinkNotification"),
                    object: nil,
                    userInfo: ["url": url]
                )
            }
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
        if !deepLinkObserverAdded {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(handleDeepLink(_:)),
                        name: Notification.Name("DeepLinkNotification"),
                        object: nil
                    )
                    deepLinkObserverAdded = true
                }
    }
    
    @objc func handleDeepLink(_ notification: Notification) {
            // Hxandle the deep link here
            if let url = notification.userInfo?["url"] as? URL {
                print("Handling deep link: \(url)")
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                            if let host = components.host {
                                switch host {
                                case "movie":
                                   
                                    if let movieID = components.queryItems?.first(where: { $0.name == "id" })?.value {
                                        print("Open movie with ID: \(movieID)")
                                        openMovieDetailPage(with: movieID)
                                    }
                                default:
                                    break
                                }
                            }
                        }
            }
        }
        
    
    func openMovieDetailPage(with movieID: String) {
        // Assuming you have a storyboard identifier for the movie detail view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            // Pass the movie ID to the movie detail view controller
            movieDetailViewController.movieID = Int(movieID)
           
            print("ketanis\(movieID)")


            // Access the app's current window
            guard let window = UIApplication.shared.windows.first else {
                print("Error: Window is nil.")
                return
            }

            // Check if the root view controller is a UINavigationController
     
            if let rootViewController = window.rootViewController,
               rootViewController is UINavigationController {
                // Push the movie detail view controller onto the existing navigation stack
                if let navigationController = rootViewController as? UINavigationController {
                    let movieDetail = Movie(title: "", overview: nil, vote_average: nil, poster_path: nil, id: Int64(movieID))
                    let dataStore = MovieDetailDataStoreImp()
                    dataStore.setupDataStore(movieDetail, apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6")
                    let router = MovieDetailRouter(viewController: movieDetailViewController, dataStore: dataStore)
                    movieDetailViewController.dataStore = MovieDetailDataStoreImp()
                    movieDetailViewController.dataStore?.selectedMovie = movieDetail
                    movieDetailViewController.router = router
                    navigationController.pushViewController(movieDetailViewController, animated: true)
                }
            } else {
                // If the root view controller is not a UINavigationController, create a new one
                let navigationController = UINavigationController(rootViewController: movieDetailViewController)
                window.rootViewController = navigationController
            }
        } else {
            // Handle the case where instantiation fails
            print("Error: Unable to instantiate MovieDetailViewController.")
        }
    }
    
//    func openMovieDetailPage(with movieID: String) {
//        // Assuming you have a storyboard identifier for the movie detail view controller
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
//            // Handle the case where instantiation fails
//            print("Error: Unable to instantiate MovieDetailViewController.")
//            return
//        }
//
//        // Pass the movie ID to the movie detail view controller
//        movieDetailViewController.movieID = Int(movieID)
//        print("ketanis \(movieID)")
//
//        // Access the app's current window
//        guard let window = UIApplication.shared.windows.first else {
//            print("Error: Window is nil.")
//            return
//        }
//
//        // Check if the root view controller is a UINavigationController
//        if let rootViewController = window.rootViewController, rootViewController is UINavigationController {
//            // Push the movie detail view controller onto the existing navigation stack
//            if let navigationController = rootViewController as? UINavigationController {
//                navigationController.pushViewController(movieDetailViewController, animated: true)
//            }
//        } else {
//            // If the root view controller is not a UINavigationController, present the movie detail view controller modally
//            window.rootViewController?.present(movieDetailViewController, animated: true, completion: nil)
//        }
//    }

  


    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

