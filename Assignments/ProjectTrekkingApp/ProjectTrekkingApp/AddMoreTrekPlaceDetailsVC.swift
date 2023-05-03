//
//  AddMoreTrekPlaceDetailsVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/29/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class AddMoreTrekPlaceDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var availability: String = String()
    var trailStart: String = String()
    var trailEnd: String = String()
    
    var trekPlace: Dictionary<String, String> = [:]
    
    
    @IBOutlet weak var trailStartNTF: UITextField!
    
    @IBOutlet weak var trailStartWTF: UITextField!
    
    @IBOutlet weak var trailEndNTF: UITextField!
    
    @IBOutlet weak var trailEndWTF: UITextField!
    
    @IBOutlet weak var trekImageIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func availabilitySV(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.availability = "Open"
        case 1:
            self.availability = "Closed"
        default:
            break
        }
    }
    
    @IBAction func selectImageBTN(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    @IBAction func addPlaceBTN(_ sender: UIButton) {
        guard let startN = self.trailStartNTF.text, !startN.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide Trek Place Start Location")
            return
        }
        
        guard let startW = self.trailStartWTF.text, !startW.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide Trek Place Start Location")
            return
        }
        
        guard let endN = self.trailEndNTF.text, !endN.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide Trek Place End Location")
            return
        }
        
        guard let endW = self.trailEndWTF.text, !endW.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide Trek Place End Location")
            return
        }
        
        guard !self.availability.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide Trek Place Availability")
            return
        }
        
        db.collection("trekPlaces").document(self.trekPlace["name"]!).setData([
            "name": self.trekPlace["name"] as Any,
            "type": self.trekPlace["type"] as Any,
            "image": self.trekPlace["name"] as Any,
            "description": self.trekPlace["description"] as Any,
            "distance": Double(self.trekPlace["distance"]!) as Any,
            "effortLevel": self.trekPlace["effortLevel"] as Any,
            "trailStartLocation": FieldValue.arrayUnion([startN, startW]) as Any,
            "trailEndLocation": FieldValue.arrayUnion([endN, endW]) as Any,
            "availability": self.availability as Any
        ]) { err in
            if let _ = err {
                self.showAlert(having: "Error", with: "Error in adding new Trek Place")
            } else {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminActivitiesScreen") as! AdminActiviesVC
                self.navigationController?.pushViewController(nextVC, animated: true)
                self.showAlert(having: "Success✅", with: "Trek Place added successfully")
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

extension AddMoreTrekPlaceDetailsVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {
            return
        }
        self.trekImageIV.image = image
        
        dismiss(animated: true, completion: nil)
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let ref = storage.child("images/\(String(describing: self.trekPlace["name"]!))")
        ref.putData(imageData, completion: {
            _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil )
    }
}

extension AddMoreTrekPlaceDetailsVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
