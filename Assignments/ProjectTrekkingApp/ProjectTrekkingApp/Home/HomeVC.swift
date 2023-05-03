//
//  HomeVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var forests: [String] = []
    var valleys: [String] = []
    var waterFalls: [String] = []
    var caves: [String] = []
    var volcanos: [String] = []
    var cities: [String] = []
    
    
    @IBOutlet weak var profileIV: UIImageView! {
        didSet {
            self.profileIV.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_ :)))
            tap.numberOfTapsRequired = 1
            self.profileIV.addGestureRecognizer(tap)
        }
    }
    
    
    @IBOutlet weak var placesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.placesTV.delegate = self
        self.placesTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.forests.removeAll()
        self.caves.removeAll()
        self.cities.removeAll()
        self.volcanos.removeAll()
        self.waterFalls.removeAll()
        self.valleys.removeAll()
        
        self.getDataFromDB()
        self.placesTV.reloadData()
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

// Go To Profile Screen
extension HomeVC {
    @IBAction func goToProfile(_ sender: UITapGestureRecognizer) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "profileScreen") as! ProfileVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension HomeVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.forests.count
        case 1:
            return self.valleys.count
        case 2:
            return self.waterFalls.count
        case 3:
            return self.caves.count
        case 4:
            return self.volcanos.count
        case 5:
            return self.cities.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Forests"
        case 1:
            return "Valleys"
        case 2:
            return "Waterfalls"
        case 3:
            return "Caves"
        case 4:
            return "Volcanos"
        case 5:
            return "Cities"
        default:
            break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.forests[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.forests[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        case 1:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.valleys[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.valleys[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        case 2:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.waterFalls[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.waterFalls[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        case 3:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.caves[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.caves[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        case 4:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.volcanos[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.volcanos[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        case 5:
            let cell = self.placesTV.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceTVC
            cell.placeName.text = self.cities[indexPath.row]
            let reference = Storage.storage().reference(withPath: "images/\(self.cities[indexPath.row])")
                reference.downloadURL { (URL, error) in
                    if let url = URL {
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                          // Error handling...
                          guard let imageData = data else { return }

                          DispatchQueue.main.async {
                              cell.placeImage.image = UIImage(data: imageData)
                          }
                        }.resume()
                      }
                }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.forests[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 1:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.valleys[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 2:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.waterFalls[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 3:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.caves[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 4:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.volcanos[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 5:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "placeDetailsScreen") as! ViewPlaceVC
            nextVC.trekPlace = self.cities[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HomeVC {
    func getDataFromDB() {
        self.db.collection("trekPlaces").getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Error in retrieving the data")
            } else {
                for doc in querySnapshot!.documents {
                    switch doc.data()["type"] as! String {
                    case "Forest":
                        self.forests.append(doc.data()["name"] as! String)
                    case "Valleys":
                        self.valleys.append(doc.data()["name"] as! String)
                    case "WaterFalls":
                        self.waterFalls.append(doc.data()["name"] as! String)
                    case "Caves":
                        self.caves.append(doc.data()["name"] as! String)
                    case "Volcanos":
                        self.volcanos.append(doc.data()["name"] as! String)
                    case "City":
                        self.cities.append(doc.data()["name"] as! String)
                    default:
                        break
                    }
                }
                self.placesTV.reloadData()
            }
        })
    }
}
