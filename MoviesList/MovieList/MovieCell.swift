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
    
    override func awakeFromNib() {
        
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowOpacity = 0.5
        img.layer.shadowOffset = CGSize(width: 2, height: 2)
        // img.layer.shadowRadius = 5
        //img.layer.cornerRadius = 40
        img.clipsToBounds = true
        wrapperView.layer.cornerRadius = 30
        
        sepView.clipsToBounds = true
        sepView.layer.cornerRadius = 10
        
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
