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
    // We will create an MKPointAnnotation for each dictionary in "locations". The
    // point annotations will be stored in this array, and then provided to the map view.
    var annotations = [MKPointAnnotation]()

    
    var mapAlertView: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrive User position
     
        self.studentsMapView.delegate = self
        self.positionManager = CLLocationManager()
        positionManager.delegate = self
        positionManager.desiredAccuracy = kCLLocationAccuracyBest
        positionManager.requestWhenInUseAuthorization()
     
        // Get Students location
        UdacityClient.sharedInstance().getStudentsLocation() { (success, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    print(messageError)
                } else {
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    self.addStudentsPinToMap(locations: appDelegate.udacityStudents)
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate

        if appDelegate.udacityStudents.count > 0 {
            self.addStudentsPinToMap(locations: appDelegate.udacityStudents)
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
                    showAlertView(message: MapErrors.brokedLink)
                }
            }
        }
    }

    // MARK: func
    func addStudentsPinToMap(locations: [UdacityStudent])  {
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        annotations.removeAll()
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
        
        print("Total Locations are: \(locations.count)")
    }
    
    func showAlertView(message: String) {
        
        self.mapAlertView = UIAlertController(title: Constants.appName,
                                                    message: message,
                                                    preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        mapAlertView!.addAction(action)
        
        present(mapAlertView!, animated: true, completion: nil)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
}
