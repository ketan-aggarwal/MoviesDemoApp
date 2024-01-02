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
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
           
            
            hiTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
          //hiTitle.font = UIFont(name: "Avenir-Medium", size: 20)
            hiTitle.textColor = .white
            hiTitle.numberOfLines = 2
        }

        
    }

