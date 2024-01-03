//
//  ViewControllerUtility.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 03/01/24.
//

import Foundation
import UIKit

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }

}
