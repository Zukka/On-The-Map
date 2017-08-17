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
        
        // Retrive User position
        
        self.studentsMapView.delegate = self
        self.positionManager = CLLocationManager()
        positionManager.delegate = self
        positionManager.desiredAccuracy = kCLLocationAccuracyBest
        positionManager.requestWhenInUseAuthorization()
        
        // Get user details
        UdacityClient.sharedInstance().getPublicUserData() { (retrivedName, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    print(messageError)
                } else {
                    print("retrivedName: \(String(describing: retrivedName))")
                }
            }
        }
        // Get Students location
        UdacityClient.sharedInstance().getStudentsLocation() { (studentsList, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    print(messageError)
                } else {
                    print("list: \(studentsList!))")
                    self.addStudentsPinToMap(locations: studentsList!)
                }
            }
        }
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

    func addStudentsPinToMap(locations: [[String: Any?]]) {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in locations {
            
            // Check if latitude and longitude have a value for prevent an error
            if dictionary["latitude"] != nil && dictionary["longitude"] != nil {
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary["firstName"] as? String
                let last = dictionary["lastName"] as? String
                let mediaURL = dictionary["mediaURL"] as? String
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first ?? "") \(last ?? "")"
                annotation.subtitle = mediaURL ?? ""
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
        }
        // When the array is complete, we add the annotations to the map.
        self.studentsMapView.addAnnotations(annotations)
    }

}
