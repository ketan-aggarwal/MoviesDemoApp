//
//  SideMenu.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 11/12/23.
//

import Foundation
import UIKit

protocol MenuControllerDelegate{
    func didSelectMenuItem(named: SideMenuItems)
}

enum SideMenuItems: String, CaseIterable{
    case popularMovies = "Popular Movies"
    case upcomingMovies = "Upcoming Movies"
    case info = "Info"
    case signout = "Sign Out"
    
}

class MenuController: UITableViewController {
     
    public var delegate: MenuControllerDelegate?
    
    private let menuItems: [SideMenuItems]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .darkGray
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        cell.backgroundColor = .darkGray
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]; delegate?.didSelectMenuItem(named: selectedItem)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
    }
}
