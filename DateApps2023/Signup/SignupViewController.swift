//
//  SignupViewController.swift
//  DateApps2023
//
//  Created by 藤門莉生 on 2023/02/15.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

/*
 参考URL: https://firebase.google.com/docs/rules/basics?authuser=0&hl=ja
 参考URL: https://cloud.google.com/firestore/docs/manage-data/add-data?hl=ja
 */
class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        signupButton.layer.cornerRadius = 20
    }
   
    /*
     TODO: リファクタリング時に、ViewModelに切り出す
     */
    private func validateUsername(username: String?) -> Bool {
        let USERNAME_MIN_LENGTH = 1
        
        guard let username = username else { return false }
        
        if username.count < USERNAME_MIN_LENGTH {
            return false
        }
        
        return true
    }
   
    /*
     TODO: リファクタリング時に、ViewModelに切り出す
     参考URL: https://yamatooo.blog/entry/2020/11/25/083000
     */
    private func validateEmail(email: String?) -> Bool {
        guard let email = email else { return false }
        
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let checkingResults = regex.matches(in: email, range: NSRange(location: 0, length: email.count))
        
        return checkingResults.count > 0
    }
    
    /*
     TODO: リファクタリング時に、ViewModelに切り出す
     */
    private func validatePassword(password: String?, confirmPassword: String?) -> Bool {
        let PASSWORD_MIN_LENGTH = 6
        
        guard let password = password, let confirmPassword = confirmPassword else { return false }
        
        if password.count < PASSWORD_MIN_LENGTH {
            return false
        }
            
        if password != confirmPassword {
            return false
        }
     
        return true
    }
   
    /*
     TODO: リファクタリング時に、ユーザー登録（FirebaseAuth）、ユーザー登録（Firestore）、画面遷移を各々のメソッドに切り出す
     */
    @IBAction func tapSignupButton(_ sender: Any) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        if validateUsername(username: username)
        && validateEmail(email: email)
        && validatePassword(password: password, confirmPassword: confirmPassword) {
            print("sign up")
            // FireAuthへの登録
            Auth.auth().createUser(withEmail: email!, password: password!) { authDataResult, error in
                if let error = error {
                    print(error)
                } else {
                    let user = User(id: authDataResult!.user.uid, name: username!)
                    let now = Date()
                    
                    // Firestoreへの登録
                    let db = Firestore.firestore()
                    db.collection("users").document(user.id).setData([
                            "name": user.name,
                            "created_at": Timestamp(date: now),
                            "updated_at": Timestamp(date: now)
                        ]) { error in
                        if let error = error {
                            print(error)
                        } else {
                            // 画面遷移
                            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            if let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as? HomeViewController {
                                self.navigationController?.pushViewController(homeVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
