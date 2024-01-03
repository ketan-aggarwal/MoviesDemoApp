//
//  AppDelegate.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        navigationAppearance()
        googleUserSignedIn()
        if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
                if let storedUserName = UserDefaults.standard.string(forKey: "userName"),
                   let storedProfileImageURLString = UserDefaults.standard.string(forKey: "userProfileImageURL"),
                   let storedProfileImageURL = URL(string: storedProfileImageURLString) {

                    // Set up your UI with stored user information
                    UserDataManager.shared.userName = storedUserName
                    UserDataManager.shared.userProfileImageURL = storedProfileImageURL
                }
            }
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let window = UIWindow(frame: UIScreen.main.bounds)
//
//            if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
//                let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
//                let navigationController = UINavigationController(rootViewController: movieViewController)
//                window.rootViewController = navigationController
//            } else {
//                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                let navigationController = UINavigationController(rootViewController: loginViewController)
//                window.rootViewController = navigationController
//            }
//
//            window.makeKeyAndVisible()
//
//            // Optional: Add a slight delay to the transition to ensure a smoother visual effect
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//            }
//
//            self.window = window
//        }
        
        
       
        
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        return true
    }
        
        func application(
          _ app: UIApplication,
          open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            
          var handled: Bool
            print("App delegate Deep link \(url)")
            
          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
            
            
          return false
        }
      

    // MARK: UISceneSession Lifecycle
    func navigationAppearance(themeColor: UIColor = .white){
    
        if let font = UIFont(name: "HelveticaNeue-Light", size: 22) {
            var attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: themeColor,
                .shadow: NSShadow()
                
            ]
        
//            UINavigationBar.appearance().backgroundColor = themeColor == .white ? .black : .white
//
//            let shadow = NSShadow()
//            shadow.shadowColor = UIColor.gray
//            shadow.shadowOffset = CGSize(width: 1, height: 1)
//            attributes[.shadow] = shadow
//            UINavigationBar.appearance().titleTextAttributes = attributes
            
            let barAppearance = UINavigationBar.appearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeColor]
            barAppearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            barAppearance.shadowImage = UIImage()
            barAppearance.isTranslucent = true
        }
        
    }
    
    func googleUserSignedIn(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
              UserDefaults.standard.set(false, forKey: "isUserSignedIn")
          } else {
              UserDefaults.standard.set(true, forKey: "isUserSignedIn")
          }
        }
    }
    
   

    func clearAllMoviesFromCoreData() {
        let context = CoreDataStack.shared.managedObjectContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MovieEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error clearing all movies from Core Data: \(error)")
        }
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

