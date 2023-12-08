//
//  AppDelegate.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
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
        clearAllData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func clearAllData() {
        let context = CoreDataStack.shared.managedObjectContext // Replace with your Core Data stack

        // Create a fetch request for all entities in your Core Data model
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MovieEntity")

        // Create a batch delete request with the fetch request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // Execute the batch delete request
            try context.execute(batchDeleteRequest)

            // Save the context to persist the changes
            try context.save()
        } catch {
            print("Error clearing Core Data: \(error.localizedDescription)")
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

