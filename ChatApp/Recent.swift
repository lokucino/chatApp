//
//  Recent.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-03.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

// universal necessary variables
let firebase = FIRDatabase.database().reference()
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser

// MARK:- Helper Functions

private let dateFormat = "yyyyMMddHHmmss"

// universal dateFormat: textual representation of date and time
func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}