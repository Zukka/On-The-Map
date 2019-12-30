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
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Constants
    let textfieldDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(textField: textFieldEmail)
        prepareTextField(textField: textFieldPassword)
    }

    // MARK : TextField funcs
    func prepareTextField(textField: UITextField) {
        textField.delegate = textfieldDelegate
    }

    // MARK: @IBAction
    
    // Start the login process
    @IBAction func loginPressed(_ sender: Any) {
        
        guard textFieldEmail.text! != "" else {
            showAlertView(message: LoginErrors.emptyEmail)
            return
        }
        
        guard textFieldPassword.text! != "" else {
            showAlertView(message: LoginErrors.emptyPassword)
            return
        }
        startActivityIndicator()
        UdacityClient.sharedInstance().postNewSession(username: textFieldEmail.text!, password: textFieldPassword.text!) { (success, error) in
            performUIUpdatesOnMain {
                self.stopActivityIndicator()
                if let error = error {
                    let messageError =  "Error: \(String(describing: error.code)) - \(String(describing: error.localizedDescription))"
                    self.displayError(messageError)
                } else {
                    self.completeLogin()
                }
            }
        }
    }
    
    // Open safari in app for sign up
    @IBAction func signUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    // MARK: Login
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }

    // MARK : Activity Indicator
    
    func startActivityIndicator() {
        loginActivityIndicator.isHidden = false
        loginActivityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        loginActivityIndicator.isHidden = true
        loginActivityIndicator.stopAnimating()
    }
}

// MARK: - LoginViewController Alerts

private extension LoginViewController {
    
    // MARK: Alert
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            showAlertView(message: errorString)
        }
    }
    
    func showAlertView(message: String) {
        
        self.failLoginAlertView = UIAlertController(title: Constants.appName,
                                                 message: message,
                                                 preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        failLoginAlertView!.addAction(action)
        
        present(failLoginAlertView!, animated: true, completion: nil)
    }
}
