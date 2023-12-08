//
//  MovieCell.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import Foundation

import UIKit
import QuartzCore


class MovieCell: UITableViewCell{
    

    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var img: UIImageView!
    

   

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib() {
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowOpacity = 0.5
        img.layer.shadowOffset = CGSize(width: 2, height: 2)
        img.layer.shadowRadius = 5
        img.layer.cornerRadius = 40
        img.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = sepView.bounds
        let topColor = UIColor.systemBlue.cgColor
        let bottomColor = UIColor.black.cgColor
        gradientLayer.colors = [topColor,bottomColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        sepView.layer.insertSublayer(gradientLayer, at: 0)
        sepView.clipsToBounds = true
        sepView.layer.cornerRadius = 10
    
        
        title.textColor = .white
        title.backgroundColor = .clear
        title.font = UIFont(name: "Avenir", size: 22)
        title.font = UIFont.boldSystemFont(ofSize: 22)
    }
   
}
