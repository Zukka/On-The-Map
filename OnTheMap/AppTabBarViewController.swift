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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK : func
    
    func completeLogout() {
        dismiss(animated: true, completion: nil)
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
