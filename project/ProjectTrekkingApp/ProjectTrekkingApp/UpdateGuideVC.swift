//
//  UpdateGuideVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class UpdateGuideVC: UIViewController {
    
    let db = Firestore.firestore()
    
    var guide: String = String()
    var guideAvailability: String = String()

    @IBOutlet weak var guideNameTF: UITextField!
    
    @IBOutlet weak var guideAgeTF: UITextField!
    
    @IBOutlet weak var guideAvailabilitySV: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.guideNameTF.isEnabled = false
        self.getDataFromDB()
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
    
    @IBAction func updateGuideBTN(_ sender: UIButton) {
        self.updateDataToDB()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminActivitiesScreen") as! AdminActiviesVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.showAlert(having: "Success✅", with: "Guide Details updated successfully")
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

extension UpdateGuideVC {
    func getDataFromDB() {
        self.db.collection("guideDetails").whereField("name", isEqualTo: self.guide).getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Error in getting data from database")
            } else {
                for doc in querySnapshot!.documents {
                    self.guideNameTF.text = (doc.data()["name"] as! String)
                    self.guideAgeTF.text = String(doc.data()["age"] as! Int)
                    self.guideAvailability = (doc.data()["availability"] as! String)
                    
                    switch self.guideAvailability {
                    case "Available":
                        self.guideAvailabilitySV.selectedSegmentIndex = 0
                    case "Unavailable":
                        self.guideAvailabilitySV.selectedSegmentIndex = 1
                    default:
                        break
                    }
                }
            }
        })
    }
    
    func updateDataToDB() {
        self.db.collection("guideDetails").document(self.guide).updateData([
            "age": self.guideAgeTF.text as Any,
            "availability": self.guideAvailability as Any
        ]) { error in
            if let _ = error {
                print("Error in updating the data to database")
            } else {
                print("Guide Details updated successfully")
            }
        }
    }
}

extension UpdateGuideVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
