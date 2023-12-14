//
//  InfoViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 11/12/23.
//

import UIKit

class InfoViewController: UIViewController {

    // Example: Displaying app information
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movies App"
        
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your go-to app for discovering and enjoying movies."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupUI()
    }

    func setupUI() {
        // Add UI elements to the view
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
                   
        ])
    }
}

