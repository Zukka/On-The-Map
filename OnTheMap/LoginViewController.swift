//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Var
    
    var failLoginAlertView: UIAlertController?
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: @IBAction
    
    // Start the login process
    @IBAction func loginPressed(_ sender: Any) {
        
        guard textFieldEmail.text! != "" else {
            showAlertView(message: loginErrors.emptyEmail)
            return
        }
        
        guard textFieldPassword.text! != "" else {
            showAlertView(message: loginErrors.emptyPassword)
            return
        }
    }
    
    // Open safari in app for sign up
    @IBAction func signUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
    }
    
    // MARK: Alert
    func showAlertView(message: String) {
        
        self.failLoginAlertView = UIAlertController(title: "On The Map",
                                                 message: message,
                                                 preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        failLoginAlertView!.addAction(action)
        
        present(failLoginAlertView!, animated: true, completion: nil)
    }

}

