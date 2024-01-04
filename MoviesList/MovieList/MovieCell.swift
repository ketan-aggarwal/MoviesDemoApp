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
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var imageGradient: UIView!
    
    override func awakeFromNib() {
        
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowOpacity = 0.5
        img.layer.shadowOffset = CGSize(width: 2, height: 2)
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        wrapperView.layer.cornerRadius = 30
        
        imageGradient.layer.cornerRadius = 10
        imageGradient.clipsToBounds = true
        sepView.clipsToBounds = true
        sepView.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
            gradientLayer.frame = imageGradient.bounds
        let topColor = UIColor.clear.cgColor
        let bottomColor = UIColor.black.cgColor
               gradientLayer.colors = [topColor,bottomColor]
               gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
               gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        imageGradient.layer.insertSublayer(gradientLayer, at: 0)
        title.textColor = .white
        title.backgroundColor = .clear
        title.font = UIFont(name: "Avenir", size: 20)
        title.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    
    func updateTheme(_ theme: Theme) {
        
        if theme == .dark {
            backgroundColor = .black
            title.textColor = .white
            desc.textColor =  .white
            wrapperView.backgroundColor = UIColor(named: "wrapperDark")
        } else {
            backgroundColor = .white
            title.textColor = .black
            desc.textColor = .black
            wrapperView.backgroundColor = UIColor(named: "wrapperLight")
        }
    }
}
