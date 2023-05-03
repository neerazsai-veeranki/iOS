//
//  UpdateMoreDetailsVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage

class UpdateMoreDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var trekPlace: String = String()
    var availability: String = String()
    
    @IBOutlet weak var startNTF: UITextField!
    
    @IBOutlet weak var startWTF: UITextField!
    
    @IBOutlet weak var endNTF: UITextField!
    
    @IBOutlet weak var endWTF: UITextField!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var availabilitySV: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getDetailsFromDB()
        self.downloadImage()
    }
    
    @IBAction func selectImageBTN(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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
    
    @IBAction func updateDetailsBTN(_ sender: UIButton) {
        self.updateDataToDB()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminActivitiesScreen") as! AdminActiviesVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.showAlert(having: "Success✅", with: "Trek Place updated successfully")
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

extension UpdateMoreDetailsVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {
            return
        }
        self.imageIV.image = image
        
        dismiss(animated: true, completion: nil)
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let ref = storage.child("images/\(String(describing: self.trekPlace))")
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

extension UpdateMoreDetailsVC {
    func getDetailsFromDB() {
        self.db.collection("trekPlaces").whereField("name", isEqualTo: self.trekPlace).getDocuments(completion: {
            (querySnapShot, error) in
            if let _ = error {
                print("Error in getting data from DB")
            } else {
                for doc in querySnapShot!.documents {
                    self.startNTF.text = ((doc.data()["trailStartLocation"] as! [String])[0])
                    self.startWTF.text = ((doc.data()["trailStartLocation"] as! [String])[1])
                    self.endNTF.text = ((doc.data()["trailEndLocation"] as! [String])[0])
                    self.endWTF.text = ((doc.data()["trailEndLocation"] as! [String])[1])
                    self.availability = (doc.data()["availability"] as! String)
                    switch doc.data()["availability"] as! String {
                    case "Open":
                        self.availabilitySV.selectedSegmentIndex = 0
                    case "Closed":
                        self.availabilitySV.selectedSegmentIndex = 1
                    default:
                        break
                    }
                }
            }
        })
    }
    
    func downloadImage() {
        let reference = Storage.storage().reference(withPath: "images/\(self.trekPlace)")
            reference.downloadURL { (URL, error) in
                if let url = URL {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                      // Error handling...
                      guard let imageData = data else { return }

                      DispatchQueue.main.async {
                          self.imageIV.image = UIImage(data: imageData)
                      }
                    }.resume()
                  }
            }
    }
    
    func updateDataToDB() {
        self.db.collection("trekPlaces").document(self.trekPlace).updateData([
            "trailStartLocation": FieldValue.arrayUnion([self.startNTF.text as Any , self.startWTF.text as Any]),
            "trailEndLocation": FieldValue.arrayUnion([self.endNTF.text as Any, self.endWTF.text as Any]),
            "availability": self.availability as Any
        ]) { err in
            if let _ = err {
                print("Error in updating the data to database")
            } else {
                print("Data updated sucessfully")
            }
        }
    }
}

extension UpdateMoreDetailsVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
