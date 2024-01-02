//
//  UserDataManager.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 31/12/23.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()

    var userName: String?
    var userProfileImageURL: URL?
}
