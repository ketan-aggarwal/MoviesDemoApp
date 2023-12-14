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
        
       // clearAllMoviesFromCoreData()
        let viewController = MovieViewController()
               if let font = UIFont(name: "HelveticaNeue-Light", size: 22) {
                   var attributes: [NSAttributedString.Key: Any] = [
                       .font: font,
                       .foregroundColor: UIColor.white,
                       .shadow: NSShadow()
                   ]
                   
                   let shadow = NSShadow()
                   shadow.shadowColor = UIColor.gray
                   shadow.shadowOffset = CGSize(width: 1, height: 1)
                   attributes[.shadow] = shadow
                   UINavigationBar.appearance().titleTextAttributes = attributes
               }
      
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        func application(
          _ app: UIApplication,
          open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
          var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
          return false
        }
      
        
        func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
          return true
        }
        return true
    }
   

    // MARK: UISceneSession Lifecycle

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

