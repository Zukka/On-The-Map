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
    
    // We will create an MKPointAnnotation for each dictionary in "locations". The
    // point annotations will be stored in this array, and then provided to the map view.
    var annotations = [MKPointAnnotation]()
    var mapAlertView: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataMap), name: NSNotification.Name(rawValue: "loadMap"), object: nil)
        
        // Retrive User position
     
        self.studentsMapView.delegate = self
        AppTabBarViewController.indicator.startAnimating()
        // Get Students location
        UdacityClient.sharedInstance().getStudentsLocation() { (success, error) in
            performUIUpdatesOnMain {
                // stop activity indicator
                AppTabBarViewController.indicator.stopAnimating()
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    self.showAlertView(message: messageError)
                } else {
                    self.addStudentsPinToMap(locations: Students.sharedStudents.members)
                }
            }

        }
    }

    override func viewDidAppear(_ animated: Bool) {
            if Students.sharedStudents.members.count > 0 {
            // Remove older mapview annotations from the map
            studentsMapView.removeAnnotations(studentsMapView.annotations)
            self.addStudentsPinToMap(locations: Students.sharedStudents.members)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                // Check if link is valid before open it
                let isValidLink = NSURL(string: toOpen)
                if (isValidLink != nil) {
                    UIApplication.shared.open(URL(string: toOpen)!)
                } else {
                    showAlertView(message: LinkErrors.brokedLink)
                }
            }
        }
    }
    
    // MARK: func
    func addStudentsPinToMap(locations: [UdacityStudent])  {
        
        // Remove older mapview annotations from the map
        studentsMapView.removeAnnotations(studentsMapView.annotations)
        annotations.removeAll()

        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        for dictionary in locations {
            // Check if latitude and longitude have a value for prevent an error
            if dictionary.latitude != -999999 && dictionary.longitude != -999999 {
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
        }
        // When the array is complete, we add the annotations to the map.
        self.studentsMapView.addAnnotations(annotations)
        
    }
    
    
    @objc func reloadDataMap(){
        self.addStudentsPinToMap(locations: Students.sharedStudents.members)
    }
}

// MARK: - StudentsMapViewController Alerts

private extension StudentsMapViewController {
    func showAlertView(message: String) {
        
        self.mapAlertView = UIAlertController(title: Constants.appName,
                                                    message: message,
                                                    preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        mapAlertView!.addAction(action)
        
        present(mapAlertView!, animated: true, completion: nil)
    }
    
}
