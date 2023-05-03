//
//  UpdateTrekPlaceVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class UpdateTrekPlaceVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let places = ["Forest", "Valleys", "WaterFalls", "Caves", "City", "Volcanos"]
    
    var trekPlace: String = String()
    var trekPlaceType: String = String()
    var trekEffort: String = String()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var trekPlaceTF: UITextField!
    
    @IBOutlet weak var placeTypePV: UIPickerView!
    
    @IBOutlet weak var distanceTF: UITextField!
    
    @IBOutlet weak var effortLevelSV: UISegmentedControl!
    
    @IBOutlet weak var descriptionTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.placeTypePV.dataSource = self
        self.placeTypePV.delegate = self
        
        self.trekPlaceTF.isEnabled = false
        self.getDetailsFromDB()
    }
    
    
    @IBAction func effortLevelSV(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.trekEffort = "Beginner"
        case 1:
            self.trekEffort = "Moderate"
        case 2:
            self.trekEffort = "Hard"
        default:
            break
        }
    }
    
    
    @IBAction func updateMoreDetailsBTN(_ sender: UIButton) {
        self.updateToDB()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateMoreDetailsScreen") as! UpdateMoreDetailsVC
        nextVC.trekPlace = self.trekPlace
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.places.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.places[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.trekPlaceType = self.places[row]
    }

}

extension UpdateTrekPlaceVC {
    func getDetailsFromDB() {
        self.db.collection("trekPlaces").whereField("name", isEqualTo: self.trekPlace).getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Unbale to get details from database")
            } else {
                for doc in querySnapshot!.documents {
                    self.trekPlaceTF.text = (doc.data()["name"] as! String)
                    self.descriptionTV.text = (doc.data()["description"] as! String)
                    self.trekPlaceType = (doc.data()["type"] as! String)
                    switch doc.data()["type"] as! String {
                    case "Forest":
                        self.placeTypePV.selectRow(0, inComponent: 0, animated: true)
                    case "Valleys":
                        self.placeTypePV.selectRow(1, inComponent: 0, animated: true)
                    case "WaterFalls":
                        self.placeTypePV.selectRow(2, inComponent: 0, animated: true)
                    case "Caves":
                        self.placeTypePV.selectRow(3, inComponent: 0, animated: true)
                    case "City":
                        self.placeTypePV.selectRow(4, inComponent: 0, animated: true)
                    case "Volcanos":
                        self.placeTypePV.selectRow(5, inComponent: 0, animated: true)
                    default:
                        break
                    }
                    self.distanceTF.text = String(doc.data()["distance"] as! Double)
                    self.trekEffort = (doc.data()["effortLevel"] as! String)
                    switch doc.data()["effortLevel"] as! String {
                    case "Beginner":
                        self.effortLevelSV.selectedSegmentIndex = 0
                    case "Moderate":
                        self.effortLevelSV.selectedSegmentIndex = 1
                    case "Hard":
                        self.effortLevelSV.selectedSegmentIndex = 2
                    default:
                        break
                    }
                }
            }
        })
    }
    
    func updateToDB() {
        self.db.collection("trekPlaces").document(self.trekPlace).updateData([
            "description": self.descriptionTV.text as Any,
            "type": self.trekPlaceType as Any,
            "distance": (Double(self.distanceTF!.text!)) as Any,
            "effortLevel": self.trekEffort as Any,
        ]) { err in
            if let _ = err {
                print("Error in updating the data to database")
            } else {
                print("Data updated sucessfully")
            }
        }
    }
}
