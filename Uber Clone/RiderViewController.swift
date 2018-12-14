//
//  RiderViewController.swift
//  Uber Clone
//
//  Created by Emre Durukan on 12.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callUberButton: UIButton!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
//            map.removeAnnotation(map.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let email = Auth.auth().currentUser?.email {
            // Check current record exist
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                self.uberHasBeenCalled = true
                self.callUberButton.setTitle("Cancel Uber", for: .normal)
                Database.database().reference().child("RideRequests").removeAllObservers()
            }
        }
    }

    @IBAction func pressedLogout(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressedCallUber(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email {
            if uberHasBeenCalled {
                // Remove current record
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                    snapshot.ref.removeValue()
                    Database.database().reference().child("RideRequests").removeAllObservers()
                }
                uberHasBeenCalled = false
                callUberButton.setTitle("Call an Uber", for: .normal)
            } else {
                let rideRequestDictionary : [String : Any] = ["email":email,"lat":userLocation.latitude,"lon":userLocation.longitude]
                
                // Create new record
                Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                
                uberHasBeenCalled = true
                callUberButton.setTitle("Cancel Uber", for: .normal)
            }
        }
    }
    
}
