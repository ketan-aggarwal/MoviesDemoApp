//
//  ActivityIndicatorManager.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 30/10/23.
//

import Foundation

import UIKit
class ActivityIndicatorManager{
    
    static let shared = ActivityIndicatorManager()
    
    let activityIndicator = UIActivityIndicatorView(style : .large)
    
    private init(){
        
    }
    
    func showActivityIndicator() {
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            activityIndicator.center = keyWindow.center
            activityIndicator.startAnimating()
            keyWindow.addSubview(activityIndicator)
        }
    }
    
    func hideActivityIndicator() {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        
    }
}
