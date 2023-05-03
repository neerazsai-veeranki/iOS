//
//  RegisterVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var registerBTN: UIButton!
    
    @IBAction func registerBTN(_ sender: UIButton) {
        guard let email = self.emailIDTF.text else {
            return
        }
        
        guard let password = self.passwordTF.text else {
            return
        }
        
        guard let confirmPwd = self.confirmPasswordTF.text else {
            return
        }
        
        if(email.isEmpty && password.isEmpty && confirmPwd.isEmpty) {
            self.showAlert(having: "Info", with: "Please fill in the contents")
        }
        
        if(!email.hasSuffix("@gmail.com")) {
            self.showAlert(having: "Error", with: "Email ID is not correctly formatted")
        }
        
        if(password.count < 6) {
            self.showAlert(having: "Error", with: "Password must be minimum 6 characters")
        }
        
        if(password == confirmPwd) {
            Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.createUserProfile(for: UserProfile(email: email))
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeVC
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        } else {
            self.showAlert(having: "Error", with: "Password mismatch. Try again!!!")
        }
    }
    
    
    @IBAction func loginBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "userLoginScreen") as! LoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func createUserProfile(for user: UserProfile) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userProfileRef = db.collection("usersProfile").document(currentUser.uid)
            
        userProfileRef.setData([
            "firstName" : user.firstName ?? "",
            "lastName" : user.lastName ?? "",
            "email": user.email ?? currentUser.email ?? "",
            "phoneNumber": user.mobile ?? "",
            "dateOfBirth": user.dateOfBirth ?? "",
            "gender" : user.gender ?? ""
        ]) { err in
            if let _ = err {
                self.showAlert(having: "Error", with: "Error in updating the document")
            } else {
                self.showAlert(having: "Success✅", with: "Account Created Sucessfully")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

