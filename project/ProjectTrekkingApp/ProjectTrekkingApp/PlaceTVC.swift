//
//  PlaceTVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class PlaceTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let db = Firestore.firestore()

    @IBOutlet weak var placeCV: UICollectionView!
    
    var placeType: String = String()
    
    var places: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.placeCV.delegate = self
        self.placeCV.dataSource = self
        
        self.getDataFromDB()
        self.placeCV.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PlaceTVC {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.placeCV.dequeueReusableCell(withReuseIdentifier: "trekPlace", for: indexPath) as! PlaceCVC
        cell.placeName.text = self.places[indexPath.row]
        return cell
    }
}

extension PlaceTVC {
    func getDataFromDB() {
        self.db.collection("trekPlaces").whereField("type", isEqualTo: self.placeType).getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Error in retrieving data from database")
            } else {
                for doc in querySnapshot!.documents {
                    self.places.append(doc.data()["name"] as! String)
                }
                print(self.places)
                self.placeCV.reloadData()
            }
        })
    }
}
