//
//  ViewPlaceVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import EventKit
import EventKitUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Lottie

class ViewPlaceVC: UIViewController, EKEventEditViewDelegate {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    @IBOutlet weak var animationView: LottieAnimationView!
    
    @IBOutlet weak var placeLBL: UILabel!
    
    @IBOutlet weak var distanceLBL: UILabel!
    
    @IBOutlet weak var effortLBL: UILabel!
    
    @IBOutlet weak var placeDescTV: UITextView!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var savedBTN: UIButton!
    
    @IBOutlet weak var bookGuideBTN: UIButton!
    
    @IBOutlet weak var startTripBTN: UIButton!
    
    @IBOutlet weak var splitBTN: UIButton!
    
    @IBOutlet weak var mapsBTN: UIButton!
    
    var trekPlace: String = ""
    var date: Date = Date()
    var isAvailable: String = String()
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.animationView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.downloadImage()
        self.getDataFromDB(of: self.trekPlace)
        
        print(self.isAvailable)
    }
    
    @IBAction func saveBTN(_ sender: UIButton) {
        self.db.collection("usersProfile").document(Auth.auth().currentUser!.uid).updateData([
            "savedPlaces": FieldValue.arrayUnion([self.trekPlace]) as Any
        ]) { error in
            if let _ = error {
                print("Error in updating the data")
            } else {
                self.showAlert(having: "Success✅", with: "Successfully added to Saved Collection")
            }
        }
    }
    
    @IBAction func bookGuideBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "guidesScreen") as! BookAGuideVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func startBTN(_ sender: UIButton) {
        
        self.addEventToCalendar()
        
//        let forSplitWise = UIAlertController(title: "Survey", message: "Would you like to split money 💶 with your troops?", preferredStyle: .alert)
//        let likeToSplit = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
//            self.performSegue(withIdentifier: "toSplitWise", sender: self)
//         })
//
//
//
//        let noSplit = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in })
//        forSplitWise.addAction(likeToSplit)
//        forSplitWise.addAction(noSplit)
//
//        self.present(forSplitWise, animated: true, completion: nil)
    }
    
    @IBAction func splitMoney(_ sender: UIButton) {
        
    }
    
    @IBAction func showMaps(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let i = segue.identifier, i == "showMaps" {
            let desVC = segue.destination as? MapVC
            
            desVC?.trekPlace = self.trekPlace
        }
    }
}



extension ViewPlaceVC {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func addEventToCalendar() {
        self.eventStore.requestAccess(to: EKEntityType.event, completion: {
            (granted, error) in
            DispatchQueue.main.async {
                if((granted) && (error == nil)) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = "Go for Trek to: " + self.trekPlace
                    event.startDate = self.date
                    event.endDate = self.date
                    event.notes = """
                                
                                Place: \(self.trekPlace)
                                Distance: \(String(describing: (self.distanceLBL.text)!)) miles
                                Details: \(String(describing: (self.placeDescTV.text)!))
                                
                                """
                    
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
    }
}


extension ViewPlaceVC {
    func getDataFromDB(of place: String) {
        self.db.collection("trekPlaces").whereField("name", isEqualTo: place).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for doc in querySnapshot!.documents {
                    self.placeLBL.text = doc.data()["name"] as? String
                    self.distanceLBL.text = String(doc.data()["distance"] as! Double)
                    self.effortLBL.text = doc.data()["effortLevel"] as? String
                    self.placeDescTV.text = doc.data()["description"] as? String
                    self.isAvailable = (doc.data()["availability"] as! String)
                }
                if(self.isAvailable == "Closed") {
                    self.animationView.isHidden = false
                    self.animationView.animation = LottieAnimation.named("No Access")
                    self.animationView.backgroundColor = .clear
                    self.animationView.loopMode = .playOnce
                    self.animationView.play()
                    
                    self.savedBTN.isEnabled = false
                    self.bookGuideBTN.isEnabled = false
                    self.splitBTN.isEnabled = false
                    self.mapsBTN.isEnabled = false
                    self.startTripBTN.isEnabled = false
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
}


// Alert
extension ViewPlaceVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
