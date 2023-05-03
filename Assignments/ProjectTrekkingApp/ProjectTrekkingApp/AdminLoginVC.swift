//
//  AdminLoginVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/28/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AdminLoginVC: UIViewController {
    
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func adminLoginBTN(_ sender: UIButton) {
        guard let username = self.usernameTF.text else {
            return
        }
        
        guard let password = self.passwordTF.text else {
            return
        }
        
        if(username.isEmpty && password.isEmpty) {
            self.showAlert(having: "Info⚠️", with: "Please fill in the contents")
        }
        
        if(!(username == "admin@gmail.com")) {
            self.showAlert(having: "Error❌", with: "Incorrect Admin Username")
        }
        
        if(!(password == "admin@1234")) {
            self.showAlert(having: "Error❌", with: "Incorrect Admin Password")
        }
        
        if((username == "admin@gmail.com") && (password == "admin@1234")) {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminActivitiesScreen") as! AdminActiviesVC
            self.navigationController?.pushViewController(nextVC, animated: true)
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
    
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

}
