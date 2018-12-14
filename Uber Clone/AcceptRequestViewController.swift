//
//  AcceptRequestViewController.swift
//  Uber Clone
//
//  Created by Emre Durukan on 14.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptRequestViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var requestLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        map.addAnnotation(annotation)
    }
    

    @IBAction func acceptRequest(_ sender: Any) {
        // Update the ride Request
        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat":self.driverLocation.latitude, "driverLon":self.driverLocation.longitude])
            Database.database().reference().child("RideRequests").removeAllObservers()
        }
        
        // Give direction
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.requestEmail
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
    }
    

}
