//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 18/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: @IBOutlet
    
    // Search - first group (start visible)
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textFieldPlace: UITextField!
    
    // Result - second group (start hidden)
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textFieldLink: UITextField!
    @IBOutlet weak var resultMapView: MKMapView!
    
    // MARK: Var
    
    var geocodeFailAlertView: UIAlertController?
    var coordinates: CLLocationCoordinate2D?
    var studentPosition: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add corner to buttons
        searchButton.addCorner(value: 10)
        submitButton.addCorner(value: 10)
        
        showStartLayout(show: true)
    }

    // MARK: @IBAction
    
    @IBAction func cancelPosting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
    @IBAction func searchPressed(_ sender: Any) {
        guard textFieldPlace.text != "" else {
            showAlertView(message: "Place field is empty.")
            return
        }
        geocodeStringAddress(address: textFieldPlace.text!)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        // Check if is a valid link
        let startLinkChars = "https://"
        guard startLinkChars.characters.contains(textFieldLink.text!.lowercased().characters.first!) else {
            showAlertView(message: LinkErrors.startLink)
            return
        }
        
        let isValidlink = NSURL(string: textFieldLink.text!)
        guard isValidlink != nil else {
            showAlertView(message: LinkErrors.brokedLink)
            return
        }
        
        // Call correct func for update or add a new Student pin position
        if UdacityClient.sharedInstance().userLocationShared {
            // Update student pin position
            UdacityClient.sharedInstance().putStudentLocation(mapString: textFieldPlace.text!, mediaURL: textFieldLink.text!, latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, completionHandlerForPutStudentLocation: { (success, error) in
                performUIUpdatesOnMain {
                    
                    if error != nil {
                        let messageError =  "Error: \(String(describing: error!.code)) - \(String(describing: error!.localizedDescription))"
                        self.showAlertView(message: messageError)
                    } else {
                        // Return to previous ViewController (MAP or LIST students PIN)
                        self.cancelPosting((Any).self)
                    }
                }
            })
            
        } else {
            // Post a first student pin position
            UdacityClient.sharedInstance().postStudentLocation(mapString: textFieldPlace.text!, mediaURL: textFieldLink.text!, latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, completionHandlerForPostingStudentLocation: { (success, error) in
                performUIUpdatesOnMain {
                    if error != nil {
                        let messageError =  "Error: \(String(describing: error!.code)) - \(String(describing: error!.localizedDescription))"
                        self.showAlertView(message: messageError)
                    } else {
                        // Return to previous ViewController (MAP or LIST students PIN)
                        self.cancelPosting((Any).self)
                    }
                }
            })
        }
    }
    
    func geocodeStringAddress(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemark, error) in
            if error != nil {
                let messageError =  "Error: \(String(describing: error!.localizedDescription))"
                self.showAlertView(message: messageError)
            } else if placemark!.count > 0 {
                let placemark = placemark![0]
                let location = placemark.location
                self.coordinates = location!.coordinate
                self.showMap()
            }
        }
    }
    
    func showMap() {
        
        showStartLayout(show: false)
        
        //  MKCoordinateSpanMake define the extension of the  area to show
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegion(center: coordinates!, span: span)
        resultMapView.setRegion(region, animated: true)
        
        // Drop a pin at new student position
        let studentAnnotation: MKPointAnnotation = MKPointAnnotation()
        studentAnnotation.coordinate = coordinates!
        studentAnnotation.title = "Current location"
        resultMapView.addAnnotation(studentAnnotation)
    }
    
    func showStartLayout(show: Bool) {
        searchView.isHidden = !show
        resultView.isHidden = show
    }
    
}

// MARK: - PostingViewController Alerts
    
private extension PostingViewController {
    
    func showAlertView(message: String) {
        
        self.geocodeFailAlertView = UIAlertController(title: Constants.appName,
                                                    message: message,
                                                    preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        geocodeFailAlertView!.addAction(action)
        
        present(geocodeFailAlertView!, animated: true, completion: nil)
    }

}

extension UIView {
    func addCorner(value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    func addBorder(value: CGFloat) {
        self.layer.borderWidth = 3
    }
    
    func addLabelBorder() {
        self.layer.borderWidth = 1
    }
    
    func addOpacity(value: Float) {
        self.layer.opacity = value
    }
    
    func addShadows() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
    }
}

