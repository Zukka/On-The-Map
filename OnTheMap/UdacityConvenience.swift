//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 21/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
        // MARK: PUT func
    func putStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPutStudentLocation: @escaping (_ result: Bool?, _ error: NSError?) -> Void)  {
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [UdacityClient.ParameterKeys.objectID: self.userObjectId]
        let mutableMethod: String = Methods.StudentLocation
        let isUdacityRequest = false
        let jsonBody = "{\(ParameterKeys.UniqueKey): \(self.userID!), \(ParameterKeys.FirtstName): \(self.userFirstName!), \(ParameterKeys.LastName): \(self.userLastName!),\(ParameterKeys.MapString): \(mapString), \(ParameterKeys.MediaURL): \(mediaURL),\(ParameterKeys.Latitude): \(latitude), \(ParameterKeys.Longitude): \(longitude)}"
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody, isUdacityRequest: isUdacityRequest) { (results, error) in
            if let error = error {
                completionHandlerForPutStudentLocation(nil, error)
            } else {
                completionHandlerForPutStudentLocation(true, nil)
            }
        }

    }
    
    // MARK: DELETE func
    
    func deleteSession(completionHandlerForDELETE: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.Session
        let isUdacityRequest = true
       
        let _ = taskForDELETEMethod(mutableMethod, parameters: parameters, isUdacityRequest: isUdacityRequest) { (result, error) in
            if error != nil {
                completionHandlerForDELETE(false, error as NSError?)
                return
            }
            if let statusErrorCode = result?[UdacityClient.JSONResponseKeys.StatusErrorCode] as? Int {
                let statusErrorDescription = result?[UdacityClient.JSONResponseKeys.StatusErrorMessage] as? String
                let errorDescription = [NSLocalizedDescriptionKey : "\(String(describing: statusErrorDescription!))"]
                completionHandlerForDELETE(true, NSError(domain: "deleteSession", code: statusErrorCode, userInfo: errorDescription))
            } else {
                completionHandlerForDELETE(true, nil)
            }
        }
    }

    // MARK: POST func
    
    func postNewSession( username: String,  password: String, completionHandlerForNewSession: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let isUdacityRequest = true
        /* 2. Make the request */
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody, isUdacityRequest: isUdacityRequest) { (results, error) in
            if let error = error {
                completionHandlerForNewSession(nil, error)
            } else {
                if let statusErrorCode = results?[UdacityClient.JSONResponseKeys.StatusErrorCode] as? Int {
                    let statusErrorDescription = results?[UdacityClient.JSONResponseKeys.StatusErrorMessage] as? String
                    let errorDescription = [NSLocalizedDescriptionKey : "\(String(describing: statusErrorDescription!))"]
                    completionHandlerForNewSession(true, NSError(domain: "postNewSession", code: statusErrorCode, userInfo: errorDescription))
                } else {
                    if let parsedUserID = results?[UdacityClient.JSONResponseKeys.UserAccount] as? [String:AnyObject] {
                        self.userID = parsedUserID[UdacityClient.JSONResponseKeys.UserKey] as? String
                    }
                    completionHandlerForNewSession(true, nil)
                    // GET user details (firstname and lastname)
                    self.getPublicUserData(completionHandlerForGetUSerData: { (firstName, lastName, error) in
                        if error != nil {
                            completionHandlerForNewSession(nil, error)
                        } else {
                            // Stored firstName and lastName of the student
                            self.userFirstName = firstName
                            self.userLastName = lastName
                            // GET if user have shared is student location
                            self.getStudentHaveSharedLocation(completionHandlerForGetUserLocation: { (success, error) in
                                if error != nil {
                                    completionHandlerForNewSession(nil, error)
                                } else {
                                    self.userLocationShared = success
                                }
                            })
                        }
                    })
                }
            }
        }
    }

    func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostingStudentLocation: @escaping (_ result: Bool?, _ error: NSError?) -> Void)  {
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [String:AnyObject]()
            
        let mutableMethod: String = Methods.StudentLocation
        let isUdacityRequest = false
        let jsonBody = "{\(ParameterKeys.UniqueKey): \(self.userID!), \(ParameterKeys.FirtstName): \(self.userFirstName!), \(ParameterKeys.LastName): \(self.userLastName!),\(ParameterKeys.MapString): \(mapString), \(ParameterKeys.MediaURL): \(mediaURL),\(ParameterKeys.Latitude): \(latitude), \(ParameterKeys.Longitude): \(longitude)}"
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody, isUdacityRequest: isUdacityRequest) { (results, error) in
            if let error = error {
                completionHandlerForPostingStudentLocation(nil, error)
            } else {
                // Set student posted first 'student location'
                self.userLocationShared = true
                completionHandlerForPostingStudentLocation(true, nil)
            }
        }
    }
}
