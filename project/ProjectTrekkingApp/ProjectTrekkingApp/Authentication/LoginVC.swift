//
//  LoginVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/18/23.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func loginBTN(_ sender: UIButton) {
        guard let email = self.emailIDTF.text else {
            return
        }
        
        guard let password = self.passwordTF.text else {
            return
        }
        
        if(email.isEmpty && password.isEmpty) {
            self.showAlert(having: "Info⚠️", with: "Please fill in the contents")
        }
        
        if(!email.hasSuffix("@gmail.com")) {
            self.showAlert(having: "Error❌", with: "Email ID is not correctly formatted")
        }
        
        if(password.count < 6) {
            self.showAlert(having: "Error❌", with: "Password must be minimum of 6 characters")
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                self.showAlert(having: "Error❌", with: e.localizedDescription)
            } else {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarScreen") as! UITabBarController
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func registrationBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "signupScreen") as! RegisterVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    @IBAction func forgotPasswordBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "resetpwdScreen") as! ForgotPasswordVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
