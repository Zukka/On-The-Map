//
//  CustomTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 22/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
        
    }
}
