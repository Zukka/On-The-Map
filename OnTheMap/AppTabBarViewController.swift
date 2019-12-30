//
//  AppTabBarViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 16/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class AppTabBarViewController: UITabBarController {
    
    // MARK: Var
    
    var failLogoutAlertView: UIAlertController?
    var queryUpdateAlertView: UIAlertController?
    
    static var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            activityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPressed((Any).self)
    }
    
    // MARK: - IBAction

     @IBAction func logoutPressed(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession(completionHandlerForDELETE: { (success, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    self.showAlertView(message: messageError)
                } else {
                    self.completeLogout()
                }
            }
        })
     }
    
    @IBAction func postLocationPressed(_ sender: Any) {
        UdacityClient.sharedInstance().getStudentHaveSharedLocation(completionHandlerForGetUserLocation: { (success, error) in
            performUIUpdatesOnMain {
                
                if UdacityClient.sharedInstance().userLocationShared {
                    self.showRequestUpdatePosition(message: "User \"\(UdacityClient.sharedInstance().userFirstName!) \(UdacityClient.sharedInstance().userLastName!)\" has already posted a Student Location. Would you like to overwrite their location?")
                } else {
                    self.openPostViewController()
                }
            }
        })
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        AppTabBarViewController.indicator.startAnimating()
        UdacityClient.sharedInstance().getStudentsLocation() { (success, error) in
            performUIUpdatesOnMain {
                // stop activity indicator
                AppTabBarViewController.indicator.stopAnimating()
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    self.showAlertView(message: messageError)
                } else {
                    self.refreshStudentsPosition()
                }
            }
        }
        
    }
    // MARK : func
    
    func completeLogout() {
        dismiss(animated: true, completion: nil)
    }
    
    func activityIndicator() {
        AppTabBarViewController.indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        AppTabBarViewController.indicator.style = UIActivityIndicatorView.Style.gray
        AppTabBarViewController.indicator.center = self.view.center
        self.view.addSubview(AppTabBarViewController.indicator)
    }

    func refreshStudentsPosition() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadList"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMap"), object: nil)
    }
    
    func openPostViewController() {
        self.performSegue(withIdentifier: "segueToPosting", sender: nil)
        
    }
}

// MARK: - AppTabBarViewController Alerts

private extension AppTabBarViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            showAlertView(message: errorString)
        }
    }
    
    // MARK: AlertView
    
    func showAlertView(message: String) {
        
        failLogoutAlertView = UIAlertController(title: "On The Map",
                                                    message: message,
                                                    preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        failLogoutAlertView!.addAction(action)
        
        present(failLogoutAlertView!, animated: true, completion: nil)
    }
    
    func showRequestUpdatePosition(message: String) {
        
        queryUpdateAlertView = UIAlertController(title: "On The Map",
                                                     message: message,
                                                     preferredStyle: .alert)
        // Add actions
        let actionOk = UIAlertAction(title: "Overwrite", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    self.openPostViewController()
                                    
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,
                                   handler: {(paramAction :UIAlertAction!) in
                                    self.refreshPressed((Any).self)
                                   
        })
        queryUpdateAlertView!.addAction(actionOk)
        queryUpdateAlertView!.addAction(actionCancel)
        
        present(queryUpdateAlertView!, animated: true, completion: nil)

    }
    
}
