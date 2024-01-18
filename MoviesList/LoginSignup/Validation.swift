//
//  Validation.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 08/12/23.
//

import Foundation

func isPasswordValid(_ password: String) -> Bool {
       return password.count >= 6
   }

func isUserNameValid(_ username: String) -> Bool {
       return username.count >= 3
   }

func isValidEmail(_ email: String)-> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
