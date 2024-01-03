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
 
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.isHidden = true

        addGradientBackground()
        passwordText.isSecureTextEntry = true
        emailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        username.textColor = .black
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
                self.navigateToMainScreen()
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        username.isHidden = false
        guard let email = emailText.text, let password = passwordText.text, let userName = username.text else {
                   return
               }
       
        if(email.count == 0 || password.count == 0 || userName.count == 0){
            showAlert(message: "Some Field is Empty!")
        }
        
        if !isValidEmail(email){
            showAlert(message: "Invalid Email")
        }
        
        if !isUserNameValid(userName){
            showAlert(message: "Username should have atleast 3 characters")
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
                   if let uid = Auth.auth().currentUser?.uid {
                       self.storeUserInfo(uid: uid, email: email, username: userName)
                              }
               }
        username.isHidden = true
    }
    func storeUserInfo(uid: String, email: String, username: String) {
        let db = Firestore.firestore()

        db.collection("users").document(uid).setData([
            "email": email,
            "username": username
        ]) { error in
            if let error = error {
                print("Error storing user info: \(error.localizedDescription)")
            } else {
                print("User info stored successfully")
            }
        }
    }

    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                    guard error == nil else { return }
            guard let signInResult = signInResult else { return }

                let user = signInResult.user
            let fullName = user.profile?.name
          
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            UserDataManager.shared.userName = fullName
                UserDataManager.shared.userProfileImageURL = profilePicUrl
            UserDefaults.standard.set(fullName, forKey: "userName")
            UserDefaults.standard.set(profilePicUrl?.absoluteString, forKey: "userProfileImageURL")
            UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                      self.navigateToMainScreen()
                }
      
    }

    func showAlert(message: String) {
         let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }
    
   }

