//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "/api/session"
        
        // MARK: Users data
        static let Users = "/api/users"
    }
    
    // MARK: Account
    static let UserID = "key"

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Errors
        static let StatusErrorCode = "status"
        static let StatusErrorMessage = "error"
    }
}
