//
//  MovieDetailRouter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 22/11/23.
//

import Foundation
import UIKit

protocol MovieDetailRoutingLogic {
    var viewController: UIViewController? {get set}
    var dataStore: MovieDetailDataStore {get set}
}



class MovieDetailRouter: MovieDetailRoutingLogic {
    
    var dataStore: MovieDetailDataStore
    weak  var viewController: UIViewController?
    
    
    init(viewController: MovieDetailViewController, dataStore: MovieDetailDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
        print("dataStore of MovieDetailDataStore is getting set.")
    }

    
}

