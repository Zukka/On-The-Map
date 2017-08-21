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
        let mutableMethod: String = Methods.PostStudentLocation
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
    
    /*   let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
     request.httpMethod = "POST"
     request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
     request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
     let session = URLSession.shared
     let task = session.dataTask(with: request as URLRequest) { data, response, error in
     if error != nil { // Handle error…
     return
     }
     print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
     }
     task.resume()
     
     func postToWatchlist(_ movie: TMDBMovie, watchlist: Bool, completionHandlerForWatchlist: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDWatchlist
        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        let jsonBody = "{\"\(TMDBClient.JSONBodyKeys.MediaType)\": \"movie\",\"\(TMDBClient.JSONBodyKeys.MediaID)\": \"\(movie.id)\",\"\(TMDBClient.JSONBodyKeys.Watchlist)\": \(watchlist)}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForWatchlist(nil, error)
            } else {
                if let results = results?[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForWatchlist(results, nil)
                } else {
                    completionHandlerForWatchlist(nil, NSError(domain: "postToWatchlistList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlistList"]))
                }
            }
        }
    }
    */
    
       
}
