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
    
    // MARK: GET Methods
    func getStudentHaveSharedLocation(completionHandlerForGetUserLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Parse.ApiHost)\(UdacityClient.Methods.StudentLocation)\(self.userID!)\(UdacityClient.Methods.studentLocationEnd)")!)
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
    
    func getPublicUserData(completionHandlerForGetUSerData: @escaping (_ userFirstName: String?, _ userLastName: String?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(UdacityClient.Constants.ApiScheme)://\(UdacityClient.Constants.ApiHost)\(UdacityClient.Methods.Users)/\(self.userID!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForGetUSerData(nil, nil, error as NSError?)
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
                completionHandlerForGetUSerData(nil, nil, NSError(domain: "getPublicUserData", code: 99, userInfo: parsedError))
                return
            }
            if let parsedUser = parsedResult[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                let firstName = parsedUser[UdacityClient.ParameterKeys.FirtstName] as! String
                let lastName = parsedUser[UdacityClient.ParameterKeys.LastName] as! String

                completionHandlerForGetUSerData(firstName, lastName, nil)
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
    
    // MARK: PUT
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, isUdacityRequest: Bool, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
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
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPUT)
            } else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task

 
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], isUdacityRequest: Bool, completionHandleforDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        
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
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandleforDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandleforDELETE)
            } else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandleforDELETE)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task

    }
    
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, isUdacityRequest: Bool, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        
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
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Remove range characters if isUdacityRequest is true */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if isUdacityRequest {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            } else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
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
