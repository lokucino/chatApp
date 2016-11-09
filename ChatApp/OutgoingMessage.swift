//
//  OutgoingMessage.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-08.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class OutgoingMessage {
    
    private let ref = firebase.child("Message")
    
    let messageDictionary: NSMutableDictionary // you can change the content in the dictionary
    
    init(message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "senderId", "senderName", "date", "status", "type"])
    }
    
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "latitude", "longitude", "senderId", "senderName", "date", "status", "type"])
    }
    
    init(message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        // converts pic to string
        let pic = pictureData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "picture", "senderId", "senderName", "date", "status", "type"])
    }
    
    func sendMessage(chatRoomID: String, item: NSMutableDictionary) {
        
        let reference = ref.child(chatRoomID).childByAutoId()
        
        // message token
        // NSMutableDictionary allows you to add to the dictionary
        item["messageId"] = reference.key
        
        reference.setValue(item) { (error: NSError?, ref: FIRDatabaseReference) in
            if error != nil {
                print("Error, couldn't send message -> \(error)")
            }
        }
        
        // send push notification
        
        // update recents here
        UpdateRecents(chatRoomID, lastMessage: (item["message"] as? String)!)
    }
}