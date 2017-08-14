//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
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
                completionHandlerForNewSession(true, nil)
            }
        }
        task.resume()
        
    }
    
}
