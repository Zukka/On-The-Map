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
    static var indicator = UIActivityIndicatorView()
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            activityIndicator()
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

    @IBAction func refreshPressed(_ sender: Any) {
        
        AppTabBarViewController.indicator.startAnimating()
        UdacityClient.sharedInstance().getStudentsLocation() { (success, error) in
            performUIUpdatesOnMain {
                // stop activity indicator
                AppTabBarViewController.indicator.stopAnimating()
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    self.showAlertView(message: messageError)
                    print(messageError)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadList"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMap"), object: nil)
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
        AppTabBarViewController.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        AppTabBarViewController.indicator.center = self.view.center
        self.view.addSubview(AppTabBarViewController.indicator)
    }

}

// MARK: - LoginViewController Alerts

private extension AppTabBarViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            showAlertView(message: errorString)
        }
    }
    
    // MARK: Alert
    func showAlertView(message: String) {
        
        self.failLogoutAlertView = UIAlertController(title: "On The Map",
                                                    message: message,
                                                    preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        failLogoutAlertView!.addAction(action)
        
        present(failLogoutAlertView!, animated: true, completion: nil)
    }
}
