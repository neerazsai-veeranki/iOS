//
//  SettingsVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/23/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SettingsVC: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetPasswordBTN(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser, let email = user.email, !email.isEmpty else {
            return
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
    
    
    @IBAction func logoutBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "chooseUserScreen") as! ChooseUserVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func closeBTN(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
