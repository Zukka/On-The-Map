//
//  StudentsMapViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 16/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var studentsMapView: MKMapView!
    
    var positionManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    var updatedUserPosition : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.studentsMapView.delegate = self
        self.positionManager = CLLocationManager()
        positionManager.delegate = self
        positionManager.desiredAccuracy = kCLLocationAccuracyBest
        positionManager.requestWhenInUseAuthorization()
    }

    // MARK: - MapView
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if (self.updatedUserPosition == false) {
            self.userPosition = userLocation.coordinate
            
            print("last updated position - lat: \(userLocation.coordinate.latitude) long: \(userLocation.coordinate.longitude)")
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegion(center: userPosition, span: span)
            
            mapView.setRegion(region, animated: true)
            self.updatedUserPosition = true
        }
        
    }

 

}
