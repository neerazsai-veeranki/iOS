//
//  SavedVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Lottie

class SavedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    
    @IBOutlet weak var placesCV: UICollectionView!
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var savedPlaces: [String] = []
    var images: [String] = []
    var place: String = ""
    var selectedItem: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.placesCV.dataSource = self
        self.placesCV.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedPlaces.removeAll()
        self.getData()
        self.placesCV.reloadData()
        self.animationView.isHidden = true
    }
    
    
    
}


extension SavedVC {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.placesCV.dequeueReusableCell(withReuseIdentifier: "viewPlace", for: indexPath) as! PlacesCVC
        cell.titleLBL.text = self.savedPlaces[indexPath.row]
        self.db.collection("trekPlaces").whereField("name", in: self.savedPlaces as [Any]).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                let reference = Storage.storage().reference(withPath: "images/\(self.savedPlaces[indexPath.row])")
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
                self.placesCV.reloadData()
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = indexPath.row
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
        nextVC.trekPlace = self.savedPlaces[self.selectedItem]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// Alert
extension SavedVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

extension SavedVC {
    func getData() {
        if let currentUser = Auth.auth().currentUser {
            self.db.collection("usersProfile").whereField("email", isEqualTo: currentUser.email! as Any).getDocuments(completion: {
                (querySnapshot, err) in
                if let _ = err {
                    self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
                } else {
                    for document in querySnapshot!.documents {
                        if let data = document.data()["savedPlaces"] as? [String], !data.isEmpty {
                            self.savedPlaces.append(contentsOf: data)
                        }
                        if(self.savedPlaces.count == 0) {
                            self.animationView.isHidden = false
                            self.animationView.animation = LottieAnimation.named("No Data")
                            self.animationView.backgroundColor = .clear
                            self.animationView.loopMode = .playOnce
                            self.animationView.play()
                        }
                    }
                    self.placesCV.reloadData()
                }
            })
        }
    }
    
    func removeFromSaved(place: String) {
        if let currentUser = Auth.auth().currentUser {
            self.db.collection("usersProfile").whereField("email", isEqualTo: currentUser.email as Any).getDocuments(completion: {
                (querySnapshot, err) in
                if let _ = err {
                    self.showAlert(having: "Error❌", with: "Trouble in Deleting the data")
                } else {
                    for doc in querySnapshot!.documents {
                        let docRef =  doc.reference
                        docRef.updateData(["savedPlaces": FieldValue.arrayRemove([place])])
                    }
                }
                self.placesCV.reloadData()
            })
        }
    }
}
