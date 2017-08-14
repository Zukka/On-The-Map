//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 12/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
