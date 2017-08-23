//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 17/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import Foundation
import UIKit

/*struct UdacityStudent {
    
    // MARK: Properties
    
    var latitude: Double
    var longitude: Double
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    // MARK: Initializers
    
    // construct a UdacityStudent from a dictionary
    init(dictionary: [String:AnyObject]) {
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String ?? ""
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String ?? ""
        mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaURL] as? String ?? ""
        latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as? Double ?? -999999
        longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as? Double ?? -999999
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) {
        
        // Add it to the students dictionary in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.udacityStudents.removeAll()
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            
            appDelegate.udacityStudents.append(UdacityStudent(dictionary: result))

        }
    }

}
*/

struct UdacityStudent {
    
    // MARK: Properties
    
    var latitude: Double
    var longitude: Double
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    // MARK: Initializers
    
    // construct a UdacityStudent from a dictionary
    init (firstName: String, lastName: String, mediaURL: String, latitude: Double, longitude: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

class Students {
    
    static let sharedStudents = Students()
    
    var members:[UdacityStudent] = []
    
}

