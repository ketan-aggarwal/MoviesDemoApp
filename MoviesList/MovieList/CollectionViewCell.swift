//
//  CollectionViewCell.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/12/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hiImg: UIImageView!
    @IBOutlet weak var hiTitle: UILabel!
    
    
    @IBOutlet weak var widthConstraint: UIImageView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    var collectionViewWidth: CGFloat = 120.0
    override func awakeFromNib() {
            super.awakeFromNib()
           
            
            hiTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
          //hiTitle.font = UIFont(name: "Avenir-Medium", size: 20)
            hiTitle.textColor = .white
            hiTitle.numberOfLines = 1
        
        hiImg.contentMode = .scaleAspectFit
               hiImg.clipsToBounds = true
        
       // imageWidthConstraint.constant = collectionViewWidth


        }
    func updateTheme(_ theme: Theme) {
            // Update the appearance of MovieCell based on the theme
            if theme == .dark {
                backgroundColor = .black
                hiTitle.textColor = .white
                print("is dark")
            } else {
                backgroundColor = .white
                hiTitle.textColor = .darkGray
                print("is light")
            }
        }

        
    }

