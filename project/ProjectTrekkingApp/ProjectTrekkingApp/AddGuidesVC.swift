//
//  AddGuidesVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AddGuidesVC: UIViewController {
    
    let db = Firestore.firestore()
    
    var guideAvailability:String = String()

    @IBOutlet weak var guideNameTF: UITextField!
    
    @IBOutlet weak var guideAgeTF: UITextField!
    
    @IBOutlet weak var guideAvailabilitySV: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func guideAvailabilitySV(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.guideAvailability = "Available"
        case 1:
            self.guideAvailability = "Unavailable"
        default:
            break
        }
    }
    
    
    @IBAction func addGuideBTN(_ sender: UIButton) {
        guard let name = self.guideNameTF.text, !name.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Guide Name cannot be empty")
            return
        }
        
        guard let age = self.guideAgeTF.text, !age.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Guide Age cannot be empty")
            return
        }
        
        guard !self.guideAvailability.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide guide availability")
            return
        }
        
        self.db.collection("guideDetails").document(name).setData([
            "name": name as Any,
            "age": Int(age) as Any,
            "availability": self.guideAvailability as Any,
            "isBooked": false as Any
        ]) { error in
            if let _ = error {
                print("Error in adding guide details to database")
            } else {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminActivitiesScreen") as! AdminActiviesVC
                self.navigationController?.pushViewController(nextVC, animated: true)
                self.showAlert(having: "Success✅", with: "Guide Details added successfully")
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


extension AddGuidesVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
