//
//  SideMenuHeaderView.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 04/01/24.
//

import UIKit

class SideMenuHeaderView: UIView {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    func setupUI(imageUrl: String, usernName: String){
       userImage?.layer.cornerRadius = userImage!.frame.width / 2
        userImage?.clipsToBounds = true
        
        if let profilePicUrl = UserDataManager.shared.userProfileImageURL {
            userImage?.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "defaultProfileImage"))
        } else {
            userImage.removeFromSuperview()
        }
        
        if let username = UserDataManager.shared.userName {
           // userName.text = username
            userName.text = "Ketan Aggarwal ketan aggarwal"
        }else{
            
            userName.text = "Hi User"
        }
        
    }
}
