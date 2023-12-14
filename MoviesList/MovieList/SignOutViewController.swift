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

            // Navigate to the sign-in screen or perform any other action after sign-out
            // For example, you can pop to the root view controller (assuming your root is the login screen):
            self.navigationController?.popToRootViewController(animated: true)
//        dismiss(animated: true, completion: {
//                // Optionally, pop to the root view controller
//                self.navigationController?.popToRootViewController(animated: true)
//            })
    }
    

   

}
