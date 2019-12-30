//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    // MARK: User(Student) Properties
    var userID : String? = nil
    var userFirstName : String? = nil
    var userLastName : String? = nil
    var userLocationShared: Bool = false
    var userObjectId: String? = nil
    
    // shared session
    var session = URLSession.shared

    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], isUdacityRequest: Bool, completionHandleforGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask  {
        /* 1. Set the parameters */
        let parametersWithApiKey = parameters
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parametersWithApiKey, withPathExtension: method, isUdacityRequest: isUdacityRequest))
        request.httpMethod = "GET"
        if !isUdacityRequest {
            request.addValue(UdacityClient.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(UdacityClient.Parse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // Check if there is a connection error
            if error != nil {
                completionHandleforGET(nil, error! as NSError)
                return
            }

            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandleforGET)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandleforGET)
            }
        }

        /* 7. Start the request */
        task.resume()
        
        return task

    }
    
    // MARK: PUT
    
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, isUdacityRequest: Bool, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        let parametersWithApiKey = parameters
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parametersWithApiKey, withPathExtension: method, isUdacityRequest: isUdacityRequest))
        request.httpMethod = "PUT"
        if !isUdacityRequest {
            request.addValue(UdacityClient.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(UdacityClient.Parse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // Check if there is a connection error
            if error != nil {
                completionHandlerForPUT(nil, error! as NSError)
                return
            }

            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForPUT)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForPUT)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task

 
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], isUdacityRequest: Bool, completionHandleforDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        let parametersWithApiKey = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parametersWithApiKey, withPathExtension: method, isUdacityRequest: isUdacityRequest))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // Check if there is a connection error
            if error != nil {
                completionHandleforDELETE(nil, error! as NSError)
                return
            }

            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandleforDELETE)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandleforDELETE)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task

    }
    
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, isUdacityRequest: Bool, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        let parametersWithApiKey = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parametersWithApiKey, withPathExtension: method, isUdacityRequest: isUdacityRequest))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !isUdacityRequest {
            request.addValue(UdacityClient.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(UdacityClient.Parse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // Check if there is a connection error
            if error != nil {
                completionHandlerForPOST(nil, error! as NSError)
                return
            }
            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForPOST)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForPOST)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "\(key)") != nil {
            return method.replacingOccurrences(of: "\(key)", with: value)
        } else {
            return nil
        }
    }

    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, isUdacityRequest: Bool) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        if isUdacityRequest {
            components.host = UdacityClient.Constants.ApiHost
        } else {
            components.host = UdacityClient.Parse.ApiHost
        }
        components.path = withPathExtension ?? ""
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
