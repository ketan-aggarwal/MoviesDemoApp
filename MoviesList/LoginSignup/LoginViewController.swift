//
//  LoginViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 08/12/23.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
                navigateToMainScreen()
            }
       // observeAuthenticationState()
        addGradientBackground()
        passwordText.isSecureTextEntry = true
        emailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       
    }

    func observeAuthenticationState() {
            Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
                guard let self = self else { return }

                if let user = user {
                    // User is signed in
                    print("User is signed in: \(user.uid)")
                    self.navigateToMainScreen()
                } else {
                    // No user is signed in
                    print("No user is signed in")
                }
            }
        }
    func addGradientBackground() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.blue.cgColor] // Customize the colors as needed
        gradientLayer.locations = [0.0, 2.0]
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
    func navigateToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
            navigationController?.pushViewController(movieViewController, animated: true)
        } else {
            print("Error: Unable to instantiate MovieViewController from storyboard.")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailText.text, let password = passwordText.text else {
            return
        }
        
        if(email.count == 0 || password.count == 0){
            showAlert(message: "Email or Password Field Empty!")
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error as? NSError {
                print("Firebase Auth Error Code: \(error.code)")
                if error.code == 17999 {
                    self.showAlert(message: "User does not exist. Did you mean to sign up?")
                } else {
                    // Handle other login errors
                    self.showAlert(message: "Login failed: \(error.localizedDescription)")
                }
            } else {
                // Login successful
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigateToMainScreen()
                }
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text else {
                   return
               }
        
        if(email.count == 0 || password.count == 0){
            showAlert(message: "Email or Password Field Empty!")
        }
        
        if !isValidEmail(email){
            showAlert(message: "Invalid Email")
        }
        
        if !isPasswordValid(password) {
            showAlert(message: "Password must be at least 6 characters long.")
            return
        }

               Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                   if let error = error {
                       // Handle signup error
                       self.showAlert(message: "SignUp failed: \(error.localizedDescription)")
                   } else {
                       self.showAlert(message: "SignUp Successful")
                       self.emailText.text = ""
                       self.passwordText.text = ""
                       
                   }
               }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                self.navigateToMainScreen()

            }

        }
    }
    
    
//    @IBAction func signInBtn(_ sender: Any) {
//        
//    }
    
    func showAlert(message: String) {
         let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }
    
   }

