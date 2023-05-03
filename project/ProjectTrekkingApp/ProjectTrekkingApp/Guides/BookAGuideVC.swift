//
//  BookAGuideVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class BookAGuideVC: UIViewController {

    @IBOutlet weak var guideTV: UITableView!
    
    let db = Firestore.firestore()
    var docID: String = ""
    
    var bookedGuides: [GuideDetails] = []
    var unbookedGuides: [GuideDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.guideTV.delegate = self
        self.guideTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
        self.guideTV.reloadData()
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

extension BookAGuideVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return self.bookedGuides.count
        } else {
            return self.unbookedGuides.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if(section == 0) {
            let cell = self.guideTV.dequeueReusableCell(withIdentifier: "guides", for: indexPath) as! GuideTVC
            cell.guideNameLBL.text = "Name: " + self.bookedGuides[indexPath.row].name
            cell.ageLBL.text = "Age: " + String(self.bookedGuides[indexPath.row].age)
            return cell
        } else {
            let cell = self.guideTV.dequeueReusableCell(withIdentifier: "guides", for: indexPath) as! GuideTVC
            cell.guideNameLBL.text = "Name: " + self.unbookedGuides[indexPath.row].name
            cell.ageLBL.text = "Age: " + String(self.unbookedGuides[indexPath.row].age)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let cancel = UIContextualAction(style: .destructive, title: "Cancel", handler: {
                [weak self] (action, view, completion) in
                let guide = self?.bookedGuides[indexPath.row]
                self!.cancelGuideDetails(guide: guide!)
                self?.bookedGuides.remove(at: indexPath.row)
                self?.unbookedGuides.append(guide!)
                self?.guideTV.reloadData()
                completion(true)
            })
            
            let book = UIContextualAction(style: .normal, title: "Book", handler: {
                [weak self] (action, view, completion) in
                let guide = self?.unbookedGuides[indexPath.row]
                self!.updateGuideDetails(guide: guide!)
                self?.unbookedGuides.remove(at: indexPath.row)
                self?.bookedGuides.append(guide!)
                self?.guideTV.reloadData()
                completion(true)
            })
            cancel.backgroundColor = .systemRed
            book.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [cancel, book])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Booked"
        } else {
            return "Available Guides"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

extension BookAGuideVC {
    func getData() {
        self.db.collection("guideDetails").getDocuments(completion:  {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for doc in querySnapshot!.documents {
                    if(doc.data()["isBooked"] as! Bool == false) {
                        self.unbookedGuides.append(GuideDetails(name: doc.data()["name"] as! String, age: doc.data()["age"] as! Int, isBooked: doc.data()["isBooked"] as! Bool))
                    } else {
                        self.bookedGuides.append(GuideDetails(name: doc.data()["name"] as! String, age: doc.data()["age"] as! Int, isBooked: doc.data()["isBooked"] as! Bool))
                    }
                }
                self.guideTV.reloadData()
            }
        })
    }
}

extension BookAGuideVC {
    func updateGuideDetails(guide: GuideDetails) {
        self.db.collection("guideDetails").whereField("name", isEqualTo: guide.name).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for document in querySnapshot!.documents {
                    self.docID = document.documentID
                }
                self.db.collection("guideDetails").document(self.docID).updateData([
                    "isBooked": true
                ]) {
                    err in
                        if let _ = err {
                            self.showAlert(having: "Error❌", with: "Error in updating the document")
                        } else {
                            self.showAlert(having: "Success✅", with: "Guide Booking Updated")
                        }
                }
                self.guideTV.reloadData()
            }
        })
    }
    
    func cancelGuideDetails(guide: GuideDetails) {
        self.db.collection("guideDetails").whereField("name", isEqualTo: guide.name).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for document in querySnapshot!.documents {
                    self.docID = document.documentID
                }
                self.db.collection("guideDetails").document(self.docID).updateData([
                    "isBooked": false
                ]) {
                    err in
                        if let _ = err {
                            self.showAlert(having: "Error❌", with: "Error in updating the document")
                        } else {
                            self.showAlert(having: "Success✅", with: "Guide Booking Updated")
                        }
                }
                self.guideTV.reloadData()
            }
        })
    }
}


// Alert
extension BookAGuideVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
