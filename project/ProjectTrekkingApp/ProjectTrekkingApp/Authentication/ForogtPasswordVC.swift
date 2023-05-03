//
//  ForogtPasswordVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPasswordBTN(_ sender: UIButton) {
        guard let email = self.emailIDTF.text else {
            return
        }
        
        if(email.isEmpty) {
            self.showAlert(having: "Info⚠️", with: "Please fill in the contents")
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let e = error {
                self.showAlert(having: "Error⚠️", with: e.localizedDescription)
            }
            else {
                self.showAlert(having:"Sucess✅", with: "Link has been sent to email to reset your password")
            }
        }
    }
    
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
