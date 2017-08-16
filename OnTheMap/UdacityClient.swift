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
    var failLoginAlertView: UIAlertController?

    // shared session
    var session = URLSession.shared

    // MARK: Initializers
    
    override init() {
        super.init()
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
                if let parsedUserID = parsedResult["account"] as? [String:AnyObject] {
                    self.userID = parsedUserID["key"] as? String
                }
                completionHandlerForNewSession(true, nil)
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
