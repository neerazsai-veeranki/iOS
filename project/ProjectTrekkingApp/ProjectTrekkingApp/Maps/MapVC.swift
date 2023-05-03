//
//  MapVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/22/23.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class MapVC: UIViewController {

    var trekPlace: String = ""
    var trailStartLocation: [String] = []
    var trailEndLocation: [String] = []
    var location: [[String]] = []
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let db = Firestore.firestore()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        print(self.trekPlace)
        self.getCoordinatesFromDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLocationServiceEnabled()
    }
    
    @IBAction func closeBTN(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Code for Alert Method
    func displayAlert(isServiceEnabled:Bool){
        let serviceEnableMessage = "Location services must to be enabled to use this  app feature. You can enable location services in your settings."
        let authorizationStatusMessage = "This app needs authorization to do some cool stuff with the map"
            
        let message = isServiceEnabled ? serviceEnableMessage : authorizationStatusMessage
            
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
        //create ok button
        let acceptAction = UIAlertAction(title: "OK", style: .default)
            
        //add ok button to alert
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Method for checking the authorization
    func checkAuthorizationStatus(){
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }
        else if status == .restricted || status == .denied {
            displayAlert(isServiceEnabled: false)
        }
        else if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            self.mapView.showsUserLocation = true
        }
    }
    
    // To check for location service
    func isLocationServiceEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            checkAuthorizationStatus()
        }
        else{
            displayAlert(isServiceEnabled: true)
        }
    }
    
    func getCoordinatesFromDB() {
        self.db.collection("trekPlaces").whereField("name", isEqualTo: self.trekPlace).getDocuments(completion: {
            (querySnapshot, err) in
            if let _ = err {
                self.showAlert(having: "Error❌", with: "Trouble in retrieving the data")
            } else {
                for doc in querySnapshot!.documents {
                    self.trailStartLocation.append(contentsOf: doc.data()["trailStartLocation"] as! [String])
                    self.trailEndLocation.append(contentsOf: doc.data()["trailEndLocation"] as! [String])
                }
                print(self.trailStartLocation)
                print(self.trailEndLocation)
                self.location.append(self.trailStartLocation)
                self.location.append(self.trailEndLocation)
                
                let sourceLocation = CLLocationCoordinate2D(latitude: Double(self.trailStartLocation[0])!, longitude: Double(self.trailEndLocation[1])!)
                let destinationLocation = CLLocationCoordinate2D(latitude: Double(self.trailEndLocation[0])!, longitude: Double(self.trailEndLocation[1])!)
                
                let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
                let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                
                let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
                let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
                
                let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.title = "Trail Start Point"
                if let location = sourcePlaceMark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
                
                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.title = "Trail End Point"
                if let location = destinationPlaceMark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
                
                self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
                
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.requestsAlternateRoutes = true
                directionRequest.requestsAlternateRoutes = true
                directionRequest.transportType = .walking
                
                let direction = MKDirections(request: directionRequest)
                direction.calculate { (response, err) in
                    guard let response = response else {
                        if let e = err {
                            print("Error: \(e.localizedDescription)")
                        }
                        return
                    }
                    
                    let route = response.routes[0]
                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                }
            }
        })
    }

}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}


// Alert
extension MapVC {
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
}
