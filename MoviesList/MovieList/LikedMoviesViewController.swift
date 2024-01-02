//
//  LikedMoviesViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 01/01/24.
//

import UIKit

class LikedMoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
                label.text = "Liked Movies View Controller"
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 20)
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false

                // Add the label to the view
                view.addSubview(label)

                // Set up constraints for the label
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
      print("likedcontroller")
    }
    



}
