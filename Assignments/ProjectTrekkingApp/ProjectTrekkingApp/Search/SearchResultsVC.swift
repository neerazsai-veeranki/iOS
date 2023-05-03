//
//  SearchResultsVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/22/23.
//

import UIKit
import Lottie
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SearchResultsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    var searchResults: [String] = []
    var data: [String] = []
    var finalResults: [String] = []
    var selectedItem: Int = 0
    
    @IBOutlet weak var searchResultsCV: UICollectionView!
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchResultsCV.delegate = self
        self.searchResultsCV.dataSource = self
        
        self.data.removeAll()
        print("In search results page = ", self.searchResults)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.searchResults.count == 0) {
            self.animationView.animation = LottieAnimation.named("No Search Results")
            self.animationView.backgroundColor = .clear
            self.animationView.loopMode = .playOnce
            self.animationView.play()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.searchResultsCV.dequeueReusableCell(withReuseIdentifier: "viewPlace", for: indexPath) as! PlacesCVC
        if(self.searchResults.count == 0) {
            self.animationView.animation = LottieAnimation.named("No Search Results")
            self.animationView.backgroundColor = .clear
            self.animationView.loopMode = .playOnce
            self.animationView.play()
        } else {
            let trekPlacesRef = self.db.collection("trekPlaces")
            trekPlacesRef.whereField(FieldPath.documentID(), in:  self.searchResults).getDocuments(completion: {
                (querySnapshot, err) in
                if let _ = err {
                    self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
                } else {
                    for doc in querySnapshot!.documents {
                        self.data.append(doc.data()["name"] as! String)
                    }
                    cell.titleLBL.text = self.data[indexPath.row]
                    let reference = Storage.storage().reference(withPath: "images/\(self.data[indexPath.row])")
                        reference.downloadURL { (URL, error) in
                            if let url = URL {
                                URLSession.shared.dataTask(with: url) { (data, response, error) in
                                  // Error handling...
                                  guard let imageData = data else { return }

                                  DispatchQueue.main.async {
                                      cell.imageIV.image = UIImage(data: imageData)
                                  }
                                }.resume()
                              }
                        }
                    
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = indexPath.row
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
        nextVC.trekPlace = self.data[self.selectedItem]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}



// Alert
extension SearchResultsVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    func getData() {
        print("Inside the getData()")
        let trekPlacesRef = self.db.collection("trekPlaces")
        trekPlacesRef.whereField("name", in:  self.searchResults).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for doc in querySnapshot!.documents {
                    self.data.append(doc.data()["name"] as! String)
                }
                self.finalResults.append(contentsOf: self.data)
                print(self.finalResults)
                self.searchResultsCV.reloadData()
            }
        })
    }
}
