//
//  ViewGuidesVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ViewGuidesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    var selectedGuide: String = String()
    
    var availableGuides: [String] = []
    var unavailableGuides: [String] = []

    @IBOutlet weak var guidesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.guidesTV.delegate = self
        self.guidesTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.availableGuides.removeAll()
        self.unavailableGuides.removeAll()
        
        self.getDataFromDB()
        self.guidesTV.reloadData()
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

extension ViewGuidesVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.availableGuides.count
        case 1:
            return self.unavailableGuides.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = self.guidesTV.dequeueReusableCell(withIdentifier: "guidesDetails", for: indexPath) as! GuideDetailsTVC
            cell.guideNameLBL.text = self.availableGuides[indexPath.row]
            return cell
        case 1:
            let cell = self.guidesTV.dequeueReusableCell(withIdentifier: "guidesDetails", for: indexPath) as! GuideDetailsTVC
            cell.guideNameLBL.text = self.availableGuides[indexPath.row]
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Available Guides"
        case 1:
            return "UnAvailable Guides"
        default:
            break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateGuidesScreen") as! UpdateGuideVC
            nextVC.guide = self.availableGuides[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 1:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateGuidesScreen") as! UpdateGuideVC
            nextVC.guide = self.unavailableGuides[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = indexPath.section
        
        switch section {
        case 0:
            self.selectedGuide = self.availableGuides[indexPath.row]
            self.availableGuides.remove(at: indexPath.row)
        case 1:
            self.selectedGuide = self.unavailableGuides[indexPath.row]
            self.unavailableGuides.remove(at: indexPath.row)
        default:
            break
        }
        
        let deleteGuide = UIContextualAction(style: .destructive, title: "Delete Guide", handler: {
            [weak self] (action, view, completion) in
            self?.deleteGuideFromDB(self!.selectedGuide)
            self?.guidesTV.reloadData()
            completion(true)
        })
        
        deleteGuide.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteGuide])
    }
}

extension ViewGuidesVC {
    func getDataFromDB() {
        self.db.collection("guideDetails").getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Error in getting data from database")
            } else {
                for doc in querySnapshot!.documents {
                    switch doc.data()["availability"] as! String {
                    case "Available":
                        self.availableGuides.append(doc.data()["name"] as! String)
                    case "Unavailable":
                        self.unavailableGuides.append(doc.data()["name"] as! String)
                    default:
                        break
                    }
                }
                self.guidesTV.reloadData()
            }
        })
    }
    
    func deleteGuideFromDB(_ guide: String) {
        self.db.collection("guideDetails").document(guide).delete() { error in
            if let _ = error {
                print("Error in deleting the guide")
            } else {
                print("Guide deleted sucessfully")
            }
        }
    }
}
