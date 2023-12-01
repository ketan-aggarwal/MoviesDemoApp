//
//  DetailCell.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 28/11/23.
//

import UIKit

class DetailCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var labels: [String] = ["Language","Revenue","Runtime","Release Date","Production Countries"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
