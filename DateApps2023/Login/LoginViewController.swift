//
//  LoginViewController.swift
//  DateApps2023
//
//  Created by 藤門莉生 on 2023/02/15.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
   
    private func configureUI() {
        loginButton.layer.cornerRadius = 20
    }
    
    /*
     TODO: リファクタリング時には、ViewModelに書き出す
     */
    private func validateEmail(email: String?) -> Bool {
        guard let email = email else { return false }
        
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let checkingResults = regex.matches(in: email, range: NSRange(location: 0, length: email.count))
        
        return checkingResults.count > 0
    }
   
    /*
     TODO: リファクタリング時には、ViewModelに書き出す
     */
    private func validatePassword(password: String?) -> Bool {
        let PASSWORD_MIN_LENGTH = 6
        
        guard let password = password else { return false }
        
        if password.count < PASSWORD_MIN_LENGTH {
            return false
        }
     
        return true
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if validateEmail(email: email) && validatePassword(password: password) {
            Auth.auth().signIn(withEmail: email!, password: password!) { authDataResult, error in
                if let error = error {
                    print(error)
                } else {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    if let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as? HomeViewController {
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                }
            }
        }
    }
}
