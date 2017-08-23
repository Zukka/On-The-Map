//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 17/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import Foundation
import UIKit

struct UdacityStudent {
    
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
    
}

class Students {
    
    static let sharedStudents = Students()
    
    var members:[UdacityStudent] = []
    
}

