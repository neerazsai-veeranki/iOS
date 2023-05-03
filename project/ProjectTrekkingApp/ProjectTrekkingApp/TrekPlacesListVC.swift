//
//  ViewPlacesVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/28/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class TrekPlacesListVC: UIViewController {

    @IBOutlet weak var trekPlaceTV: UITableView!
    
    let db = Firestore.firestore()
    
    var places: [(String, String)] = []
    var forests: [String] = []
    var valleys: [String] = []
    var caves: [String] = []
    var waterFalls: [String] = []
    var volcanos: [String] = []
    var cities: [String] = []
    var closed: [String] = []
    
    var selectedPlace: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.trekPlaceTV.delegate = self
        self.trekPlaceTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.forests.removeAll()
        self.cities.removeAll()
        self.valleys.removeAll()
        self.caves.removeAll()
        self.waterFalls.removeAll()
        self.volcanos.removeAll()
        self.closed.removeAll()
        
        self.getPlacesFromDB()
        self.trekPlaceTV.reloadData()
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


extension TrekPlacesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.forests.count
        case 1:
            return self.valleys.count
        case 2:
            return self.caves.count
        case 3:
            return self.waterFalls.count
        case 4:
            return self.volcanos.count
        case 5:
            return self.cities.count
        case 6:
            return self.closed.count
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
            return "Caves"
        case 3:
            return "WaterFalls"
        case 4:
            return "Volcanos"
        case 5:
            return "Cities"
        case 6:
            return "Closed Places"
        default:
            break
        }
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        switch section {
        case 0:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.forests[indexPath.row]
            return cell
        case 1:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.valleys[indexPath.row]
            return cell
        case 2:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.caves[indexPath.row]
            return cell
        case 3:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.waterFalls[indexPath.row]
            return cell
        case 4:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.volcanos[indexPath.row]
            return cell
        case 5:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.cities[indexPath.row]
            return cell
        case 6:
            let cell = self.trekPlaceTV.dequeueReusableCell(withIdentifier: "trekPlaces", for: indexPath) as! TrekPlaceTVC
            cell.placeNameLBL.text = self.closed[indexPath.row]
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
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.forests[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 1:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.valleys[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 2:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.caves[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 3:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.waterFalls[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 4:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.volcanos[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 5:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.cities[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 6:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "updateTrekPlaceScreen") as! UpdateTrekPlaceVC
            nextVC.trekPlace = self.closed[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = indexPath.section
        
        switch section {
        case 0:
            self.selectedPlace = self.forests[indexPath.row]
            self.forests.remove(at: indexPath.row)
        case 1:
            self.selectedPlace = self.valleys[indexPath.row]
            self.valleys.remove(at: indexPath.row)
        case 2:
            self.selectedPlace = self.caves[indexPath.row]
            self.caves.remove(at: indexPath.row)
        case 3:
            self.selectedPlace = self.waterFalls[indexPath.row]
            self.waterFalls.remove(at: indexPath.row)
        case 4:
            self.selectedPlace = self.volcanos[indexPath.row]
            self.volcanos.remove(at: indexPath.row)
        case 5:
            self.selectedPlace = self.cities[indexPath.row]
            self.cities.remove(at: indexPath.row)
        case 6:
            self.selectedPlace = self.closed[indexPath.row]
            self.closed.remove(at: indexPath.row)
        default:
            break
        }
        
        let deletePlace = UIContextualAction(style: .destructive, title: "Delete Place", handler: {
            [weak self] (action, view, completion) in
            self?.deletePlaceFromDB(self!.selectedPlace)
            self?.trekPlaceTV.reloadData()
            completion(true)
        })
        
        deletePlace.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deletePlace])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension TrekPlacesListVC {
    func getPlacesFromDB() {
        self.db.collection("trekPlaces").getDocuments(completion: {
            (querySnapshot, error) in
            if let _ = error {
                print("Unable to get data from database")
            } else {
                for doc in querySnapshot!.documents {
                    switch doc.data()["type"] as! String {
                    case "Forest":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.forests.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    case "Valleys":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.valleys.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    case "Caves":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.caves.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    case "WaterFalls":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.waterFalls.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    case "Volcanos":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.volcanos.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    case "City":
                        if(doc.data()["availability"] as! String == "Open") {
                            self.cities.append(doc.data()["name"] as! String)
                        } else {
                            self.closed.append(doc.data()["name"] as! String)
                        }
                    default:
                        break
                    }
                }
                self.trekPlaceTV.reloadData()
            }
        })
    }
    
    func deletePlaceFromDB(_ place: String) {
        self.db.collection("trekPlaces").document(place).delete() {
            error in
            if let _ = error {
                print("Error in deleting place")
            } else {
                print("Place deleted successfully")
            }
        }
    }
}
