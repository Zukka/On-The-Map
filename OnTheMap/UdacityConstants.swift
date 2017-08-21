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
    
    // MARK : Parse
    struct Parse {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiHost = "parse.udacity.com"
    }
    // MARK: Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "/api/session"
        
        // MARK: Users data
        static let Users = "/api/users"
        
        // MARK: Parse Students location
        static let PostStudentLocation = "/parse/classes/StudentLocation"
        static let StudentsLocation = "/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let StudentLocation = "/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22"
        static let studentLocationEnd = "%22%7D"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let UserName = "username"
        static let Password = "password"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
        
        // MARK: Map
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
        
        // MARK: Account
        static let LastName = "last_name"
        static let FirtstName = "first_name"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let UserAccount = "account"
        static let UserKey = "key"
        static let User = "user"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        // MARK: Errors
        static let StatusErrorCode = "status"
        static let StatusErrorMessage = "error"
        
    }
}
