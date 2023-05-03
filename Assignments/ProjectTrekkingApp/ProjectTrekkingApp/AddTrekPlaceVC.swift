//
//  CreatePlaceVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/28/23.
//

import UIKit

class AddTrekPlaceVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let placeTypes = ["Forest", "Valleys", "WaterFalls", "Caves", "City", "Volcanos"]
    var trekPlaceType: String = String()
    var trekDistance: Double = 0.0
    var trekEffort: String = String()
    
    var trekPlace: Dictionary<String, String> = [:]
    
    @IBOutlet weak var placeNameTF: UITextField!
    
    @IBOutlet weak var placeTypePV: UIPickerView!
    
    @IBOutlet weak var distanceTF: UITextField!
    
    @IBOutlet weak var effortLevelSV: UISegmentedControl!
    
    @IBOutlet weak var descriptionTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.placeTypePV.delegate = self
        self.placeTypePV.dataSource = self
    }
    
    
    @IBAction func didChangeEffortSV(_ sender: UISegmentedControl) {
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
    
    @IBAction func addMoreDetailsBTN(_ sender: UIButton) {
        guard let name = self.placeNameTF.text, !name.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Trek Name cannot be empty")
            return
        }
        
        guard !self.trekPlaceType.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Choose the Trek Place Type")
            return
        }
        
        guard let distance = self.distanceTF.text, !distance.isEmpty, let d = Double(distance) else {
            self.showAlert(having: "Info⚠️", with: "Not Valid value for Distance")
            return
        }
        self.trekDistance = d
        
        guard !self.trekEffort.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Choose the Trek Effort Level")
            return
        }
        
        guard let description = self.descriptionTV.text, !description.isEmpty else {
            self.showAlert(having: "Info⚠️", with: "Provide the description for the Trek Place")
            return
        }
        
        self.trekPlace["name"] = name
        self.trekPlace["type"] = self.trekPlaceType
        self.trekPlace["distance"] = String(self.trekDistance)
        self.trekPlace["effortLevel"] = self.trekEffort
        self.trekPlace["description"] = description
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "addMoreTrekDetailsScreen") as! AddMoreTrekPlaceDetailsVC
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
        return self.placeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.placeTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.trekPlaceType = self.placeTypes[row]
    }

}


extension AddTrekPlaceVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
