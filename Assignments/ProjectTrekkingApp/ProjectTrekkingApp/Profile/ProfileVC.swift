//
//  ProfileVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ProfileVC: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBOutlet weak var genderPV: UIPickerView!
    
    @IBOutlet weak var dobDP: UIDatePicker!
    
    var gender: String = ""
    var date: String = ""
    
    @IBAction func updateBTN(_ sender: UIButton) {
        guard let firstName = self.firstNameTF.text, !firstName.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "First Name field is empty")
            return
        }
        
        guard let lastName = self.lastNameTF.text, !lastName.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Last Name field is empty")
            return
        }
        
        guard let email = self.emailTF.text, !email.isEmpty, email.hasSuffix("@gmail.com") else {
            self.showAlert(having: "Error❌", with: "Email Id is empty or not correctly formatted")
            return
        }
        
        guard let mobile = self.mobileTF.text, !mobile.isEmpty, mobile.count == 10, let _ = Int(mobile) else {
            self.showAlert(having: "Error❌", with: "Phone Number field is empty or not correctly formatted")
            return
        }
        
        guard !self.gender.isEmpty, !(self.gender == "Select Gender") else {
            self.showAlert(having: "Info⚠️", with: "Please select your gender")
            return
        }
        
        guard !self.date.isEmpty, !(self.date == self.formatDate(date: Date())) else {
            self.showAlert(having: "Info⚠️", with: "Please set your date of birth")
            return
        }
        
        let user = UserProfile(firstName: firstName, lastName: lastName, email: email, mobile: mobile, gender: self.gender, dateOfBirth: self.date)
        self.createUserProfile(for: user)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Picker View Protocols
        self.genderPV.delegate = self
        self.genderPV.dataSource = self
        self.genderPV.reloadAllComponents()
        
        // Date Picker access
        self.dobDP.locale = .current
        self.dobDP.date = Date()
        self.dobDP.preferredDatePickerStyle = .compact
        self.dobDP.addTarget(self, action: #selector(dateSelected), for: UIControl.Event.valueChanged)
        
        self.getUserProfile()
    }

}


// Picker View and Date Picker
extension ProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == 0) {
            return "Select Gender"
        } else if(row == 1) {
            return "Male"
        } else {
            return "Female"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0) {
            self.gender = "Select Gender"
        } else if(row == 1) {
            self.gender = "Male"
        } else {
            self.gender = "Female"
        }
    }
    
    @IBAction func dateSelected() {
        self.date = self.formatDate(date: self.dobDP.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func stringToDate(value: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.date(from: value)!
    }
}


// Alert
extension ProfileVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

extension ProfileVC {
    func createUserProfile(for user: UserProfile) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userProfileRef = db.collection("usersProfile").document(currentUser.uid)
            
        userProfileRef.updateData([
            "firstName" : user.firstName ?? "",
            "lastName" : user.lastName ?? "",
            "email": user.email ?? currentUser.email ?? "",
            "phoneNumber": user.mobile ?? "",
            "dateOfBirth": user.dateOfBirth ?? "",
            "gender" : user.gender ?? ""
        ]) { err in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Error in updating the document")
            } else {
                self.showAlert(having: "Success✅", with: "Profile Updated Sucessfully")
            }
        }
    }
    
    func getUserProfile() {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        db.collection("usersProfile").whereField("email", isEqualTo: currentUser.email! as Any).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error", with: "Trouble in retrieving the data")
            } else {
                for document in querySnapshot!.documents {
                    self.firstNameTF.text = document.data()["firstName"] as? String
                    self.lastNameTF.text = document.data()["lastName"] as? String
                    self.emailTF.text = document.data()["email"] as? String
                    self.mobileTF.text = document.data()["phoneNumber"] as? String
                    self.gender = document.data()["gender"] as? String ?? ""
                    self.date = document.data()["dateOfBirth"] as? String ?? ""
                }
                
                // Setting the Picker View value
                if(self.gender == "Male") {
                    self.genderPV.selectRow(1, inComponent: 0, animated: true)
                } else if(self.gender == "Female") {
                    self.genderPV.selectRow(2, inComponent: 0, animated: true)
                } else {
                    self.genderPV.selectRow(0, inComponent: 0, animated: true)
                }
                
                // Setting the Date Picker value
                if(self.date == "") {
                    self.dobDP.setDate(self.stringToDate(value: self.formatDate(date: Date())), animated: true)
                } else {
                    self.dobDP.setDate(self.stringToDate(value: self.date), animated: true)
                }
            }
        })
    }
}

