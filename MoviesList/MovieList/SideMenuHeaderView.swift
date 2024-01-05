//
//  SideMenuHeaderView.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 04/01/24.
//

import UIKit
import SDWebImage

class SideMenuHeaderView: UIView {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
    }
    
//    func setupUI(imageUrl: String, usernName: String){
//       userImage?.layer.cornerRadius = userImage!.frame.width / 2
//        userImage?.clipsToBounds = true
//
//        if let profilePicUrl = UserDataManager.shared.userProfileImageURL {
//            userImage?.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "defaultProfileImage"))
//        } else {
//            userImage.removeFromSuperview()
//        }
//
//        if let username = UserDataManager.shared.userName {
//           userName.text = username
//
//            // userName.text = "Ketan Aggarwal ketan aggarwal"
//
//        }else{
//
//            userName.text = "Hi User"
//        }
//
//    }
    
    func setupUI(imageUrl: String, username: String) {
            userImage?.layer.cornerRadius = userImage!.frame.width / 2
            userImage?.clipsToBounds = true

            if let profilePicUrl = UserDataManager.shared.userProfileImageURL {
                userImage?.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "defaultProfileImage"))
            } else {
                userImage.removeFromSuperview()
            }

            if let username = UserDataManager.shared.userName {
                userNameLabel.text = username
            } else {
                userNameLabel.text = "Hi User"
            }
        }
}
