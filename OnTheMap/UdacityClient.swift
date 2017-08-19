//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    // MARK: Properties
    var userID : String? = nil
    var userFullName : String? = nil
    var userLocationShared: Bool = false

    // shared session
    var session = URLSession.shared

    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET Methods
    func getStudentHaveSharedLocation(completionHandlerForGetUserLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
//        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%2284247231%22%7D"
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%2284247%22%7D"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForGetUserLocation(false, error as NSError?)
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let parsedError = [NSLocalizedDescriptionKey : "Could not parse the data as JSON"]
                completionHandlerForGetUserLocation(false, NSError(domain: "getStudentHaveSharedLocation", code: 99, userInfo: parsedError))
                return
            }
            if let parsedLocation = parsedResult["results"] as? [[String:AnyObject]] {
               // Check if user have shared a location and set var userLocationShared
                for items in parsedLocation {
                     self.userLocationShared = !items.keys.isEmpty
                    
                }
                completionHandlerForGetUserLocation(self.userLocationShared, nil)
            }
                       
        }
        task.resume()
    }
    
    func getPublicUserData(completionHandlerForGetUSerData: @escaping (_ userName: String?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Constants.ApiHost)\(UdacityClient.Methods.Users)/\(self.userID!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForGetUSerData(nil, error as NSError?)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let parsedError = [NSLocalizedDescriptionKey : "Could not parse the data as JSON"]
                completionHandlerForGetUSerData(nil, NSError(domain: "getPublicUserData", code: 99, userInfo: parsedError))
                return
            }
            if let parsedUser = parsedResult[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                let surname = parsedUser[UdacityClient.LastName] as! String
                let fullName = parsedUser[UdacityClient.FirtstName] as! String + " " + surname
                completionHandlerForGetUSerData(fullName,nil)
            }
                        
        }
        task.resume()
    }
    
    func getStudentsLocation(completionHandlerGETStudendsLocation: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Parse.ApiHost)\(UdacityClient.Methods.StudentsLocation)")!)
        
        request.addValue(UdacityClient.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.Parse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerGETStudendsLocation(false, error as NSError?)
                return
            }
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let parsedError = [NSLocalizedDescriptionKey : "Could not parse the data as JSON"]
                completionHandlerGETStudendsLocation(true, NSError(domain: "postNewSession", code: 99, userInfo: parsedError))
                return
            }
            if let parsedUser = parsedResult["results"] as? [[String: AnyObject]] {
                UdacityStudent.studentsFromResults(parsedUser)
                completionHandlerGETStudendsLocation(true, nil)
            }
        }
        task.resume()
    }
    // MARK: POST Methods
 
    func postNewSession( username: String,  password: String, completionHandlerForNewSession: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Constants.ApiHost)\(UdacityClient.Methods.Session)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                completionHandlerForNewSession(false, error as NSError?)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let parsedError = [NSLocalizedDescriptionKey : "Could not parse the data as JSON"]
                completionHandlerForNewSession(true, NSError(domain: "postNewSession", code: 99, userInfo: parsedError))
                return
            }
            
            if let statusErrorCode = parsedResult[UdacityClient.JSONResponseKeys.StatusErrorCode] as? Int {
                let statusErrorDescription = parsedResult[UdacityClient.JSONResponseKeys.StatusErrorMessage] as? String
                let errorDescription = [NSLocalizedDescriptionKey : "\(String(describing: statusErrorDescription!))"]
                completionHandlerForNewSession(true, NSError(domain: "postNewSession", code: statusErrorCode, userInfo: errorDescription))
            } else {
                if let parsedUserID = parsedResult[UdacityClient.JSONResponseKeys.UserAccount] as? [String:AnyObject] {
                    self.userID = parsedUserID[UdacityClient.JSONResponseKeys.UserKey] as? String
                }
                completionHandlerForNewSession(true, nil)
                // GET user details (firstname and lastname)
                self.getPublicUserData(completionHandlerForGetUSerData: { (userData, error) in
                    if userData != nil {
                        self.userFullName = userData!
                        // GET if user have shared is student location
                        self.getStudentHaveSharedLocation(completionHandlerForGetUserLocation: { (success, error) in
                            if error != nil {
                                print("error")
                            } else {
                                self.userLocationShared = success
                            }
                        })
                    } else {
                        self.userFullName = "Unnamed student"
                    }
                })
            }
        }
        task.resume()
        
    }
    
    // MARK: DELETE Methods
    
    func deleteSession(completionHandlerForDELETE: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Constants.ApiHost)\(UdacityClient.Methods.Session)")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForDELETE(false, error as NSError?)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let parsedError = [NSLocalizedDescriptionKey : "Could not parse the data as JSON"]
                completionHandlerForDELETE(true, NSError(domain: "deleteSession", code: 99, userInfo: parsedError))
                return
            }
            
            if let statusErrorCode = parsedResult[UdacityClient.JSONResponseKeys.StatusErrorCode] as? Int {
                let statusErrorDescription = parsedResult[UdacityClient.JSONResponseKeys.StatusErrorMessage] as? String
                let errorDescription = [NSLocalizedDescriptionKey : "\(String(describing: statusErrorDescription!))"]
                completionHandlerForDELETE(true, NSError(domain: "deleteSession", code: statusErrorCode, userInfo: errorDescription))
            } else {
                completionHandlerForDELETE(true, nil)
            }

        }
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
