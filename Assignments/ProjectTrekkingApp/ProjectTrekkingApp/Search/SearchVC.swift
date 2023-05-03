//
//  SearchVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SearchVC: UIViewController {
    
    let db = Firestore.firestore()

    var searchPlaces: [String] = []
    var results: [String] = []
    
    var effortLevel: String = ""
    var distance: [Double] = []
    var landscapes: [String] = []
    
    
    @IBOutlet weak var effortLevelSV: UISegmentedControl!
    
    @IBOutlet weak var distanceSV: UISegmentedControl!
    
    
    @IBOutlet var landscapesBTN: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchPlaces.removeAll()
    }
    
    @IBAction func didChangeEffortSC(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.effortLevel = "Beginner"
        case 1:
            self.effortLevel = "Moderate"
        case 2:
            self.effortLevel = "Hard"
        default:
            self.effortLevel = "Beginner"
        }
    }
    
    
    @IBAction func didChangeDistanceSC(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.distance = [1, 5]
        case 1:
            self.distance = [6, 15]
        case 2:
            self.distance = [15, 100]
        default:
            self.distance = [1, 5]
        }
    }
    
    @IBAction func clearBTN(_ sender: UIButton) {
        self.landscapes.removeAll()
        self.distance.removeAll()
        self.effortLevel = ""
        
        self.effortLevelSV.selectedSegmentIndex = -1
        self.distanceSV.selectedSegmentIndex = -1
        
        for i in self.landscapesBTN  {
            i.backgroundColor = .clear
        }
    }
    
    @IBAction func searchBTN(_ sender: UIButton) {
        self.searchPlaces.removeAll()
        print("Effort Level = ", self.effortLevel)
        print("Distance Level = ", self.distance)
        if(self.landscapes.count > 0) {
            print("Landscapes = ", self.landscapes)
        } else {
            print("Landscapes = ", self.landscapes)
        }
        self.getSearchResultsFor(distance: self.distance, effortLevel: self.effortLevel, landscapes: self.landscapes)
        print("Search Places = ", self.searchPlaces)
        
    }
    
    @IBAction func landscapesBTN(_ sender: UIButton) {
        if(!self.landscapes.contains((sender.titleLabel?.text)!)) {
            sender.backgroundColor = UIColor.systemOrange
            self.landscapes.append((sender.titleLabel?.text)!)
        } else {
            self.landscapes.remove(at: self.landscapes.lastIndex(of: (sender.titleLabel?.text)!)!)
            sender.backgroundColor = .clear
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}


extension SearchVC {
    func getSearchResultsFor(distance: [Double], effortLevel effort: String, landscapes: [String]) {
        self.searchPlaces.removeAll()
        self.results.removeAll()
        let trekPlacesRef = db.collection("trekPlaces")
        trekPlacesRef
            .whereField("effortLevel", isEqualTo: effort)
            .whereField("distance", isLessThanOrEqualTo: distance[1])
            .whereField("distance", isGreaterThanOrEqualTo: distance[0])
            .whereField("type", in: landscapes)
            .getDocuments(completion: {
                (querySnapShot, err) in
                if let _ = err {
                    self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
                } else {
                    for doc in querySnapShot!.documents {
                        self.results.append(doc.data()["name"] as! String)
                    }
                    print("self.results = ", self.results)
                    self.searchPlaces.append(contentsOf: self.results)
                    print("Inside method self.searchPlaces = ", self.searchPlaces)
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "searchResultsScreen") as! SearchResultsVC
                    nextVC.searchResults = self.searchPlaces
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                    self.landscapes.removeAll()
                    self.distance.removeAll()
                    self.effortLevel = ""
                    
                    self.effortLevelSV.selectedSegmentIndex = -1
                    self.distanceSV.selectedSegmentIndex = -1
                    
                    
                    for i in self.landscapesBTN  {
                        i.backgroundColor = .clear
                    }
                }
            })
    }
}


// Alert
extension SearchVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

