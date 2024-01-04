//
//  SideMenu.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 11/12/23.
//

import Foundation
import UIKit
import WebKit
import SDWebImage

protocol MenuControllerDelegate{
    func didSelectMenuItem(named: SideMenuItems)
}

enum SideMenuItems: String, CaseIterable{
    case popularMovies = "Popular Movies"
    case upcomingMovies = "Upcoming Movies"
    case likedMovies = "Liked Movies"
    case info = "About Us"
    case signout = "Sign Out"
    
}
class ArrowMenuCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        textLabel?.textColor = UIColor.white
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        selectionStyle = .none

        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        arrowImageView.tintColor = UIColor.white
        accessoryView = arrowImageView
    }
    
   
}

class MenuController: UITableViewController{
     
    public var delegate: MenuControllerDelegate?
    private let menuItems: [SideMenuItems]
    
    var userNameLabel: UILabel?
   var userImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
       tableView.register(ArrowMenuCell.self, forCellReuseIdentifier: "arrowCell")

        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        tableView.separatorStyle = .none
           tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createHeaderView()
        
    }
    
 //   private func createHeaderView() {
        // Create circular image view
//        userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        userImageView?.contentMode = .scaleAspectFill
//        userImageView?.layer.cornerRadius = userImageView!.frame.width / 2
//        userImageView?.clipsToBounds = true
//
//        // Check if the user signed in with Google
//        if let profilePicUrl = UserDataManager.shared.userProfileImageURL {
//            userImageView?.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "defaultProfileImage"))
//        } else {
//
//            userImageView?.image = UIImage(named: "defaultProfileImage")
//        }
//
//        userNameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 60))
//        userNameLabel?.textColor = .white
//        userNameLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        userNameLabel?.numberOfLines = 2
//        userNameLabel?.lineBreakMode = .byWordWrapping
//
//
//        if let userName = UserDataManager.shared.userName {
//            userNameLabel?.text = userName
//            let wordsCount = userName.components(separatedBy: .whitespacesAndNewlines).count
//            if wordsCount <= 5 {
//                userNameLabel?.numberOfLines = 1
//            }
//        } else {
//
//            userNameLabel?.text = "Hi User"
//        }
//
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
//        containerView.addSubview(userImageView!)
//        containerView.addSubview(userNameLabel!)

    
   // }
    
    private func createHeaderView() {
        if let sideMenuHeaderView = loadSideMenuHeaderView() {
                navigationItem.titleView = sideMenuHeaderView
            }
    }
    
    private func loadSideMenuHeaderView() -> SideMenuHeaderView? {
        if let nib = Bundle.main.loadNibNamed("SideMenuHeaderView", owner: nil, options: nil)?.first as? SideMenuHeaderView {
            
            // Pass the username and profile pic URL to setupUI function
            if let profilePicUrl = UserDataManager.shared.userProfileImageURL,
               let username = UserDataManager.shared.userName {
                nib.setupUI(imageUrl: profilePicUrl.absoluteString, usernName: username)
                nib.translatesAutoresizingMaskIntoConstraints = false
            } else {
                // Handle the case where username or profile pic URL is not available
                print("Username or profile pic URL not available")
            }

            return nib
        }
        return nil
    }

   


    @objc private func toggleTheme() {
        ThemeManager.shared.toggleTheme()
    }


    init(with menuItems: [SideMenuItems]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]; delegate?.didSelectMenuItem(named: selectedItem)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor.white
    }
}
