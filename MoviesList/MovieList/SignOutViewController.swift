//
//  SignOutViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 11/12/23.
//

import UIKit
import GoogleSignIn

class SignOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        let signOutButton = UIButton(type: .system)
                signOutButton.setTitle("Sign Out", for: .normal)
                signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)

                view.addSubview(signOutButton)
                signOutButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
    
    @objc func signOutButtonTapped(_ sender: Any){
        GIDSignIn.sharedInstance.signOut()
       
            UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.set(nil, forKey: "userName")
        UserDefaults.standard.set(nil, forKey: "userProfileImageURL")
            self.navigationController?.popToRootViewController(animated: true)
        
    }
    
   
//    func clearUserData() {
//        // Reset user-related variables
//        UserDataManager.shared.userName = nil
//        UserDataManager.shared.userProfileImageURL = nil
//
//        // Clear cached data, if any
//        // For example, you might want to clear an image cache
//        // ImageCacheManager.shared.clearCache()
//
//        // Any other user-specific data to be cleared can be added here
//    }

}
