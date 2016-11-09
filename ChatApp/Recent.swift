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

// MARK: Create ChatRoom

func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String {
    
    // user 1 is current user
    let userId1: String = user1.objectId
    let userId2: String = user2.objectId
    
    var chatRoomId: String = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1.stringByAppendingString(userId2)
    } else {
        chatRoomId = userId2.stringByAppendingString(userId1)
    }
    
    let member = [userId1, userId2]
    
    // create recent
    CreateRecent(userId1, chatRoomID: chatRoomId, members: member, withUserUsername: user2.name!, withUserUserId: userId2)
    CreateRecent(userId2, chatRoomID: chatRoomId, members: member, withUserUsername: user1.name!, withUserUserId: userId1)
    
    return chatRoomId
}

// MARK: Create RecentItem

func CreateRecent(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserId: String){
    
    firebase.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
        
        var createRecent = true
        
        // check if we have a result
        if snapshot.exists() {
            for recent in snapshot.value!.allValues {
                
                if recent["userId"] as! String == userId {
                    createRecent = false
                }
            }
        }
        
        if createRecent {
            
            // create recent if it doesnt exist
            CreateRecentItem(userId, chatRoomID: chatRoomID, members: members, withUserUsername: withUserUsername, withUserUserID: withUserUserId)
        }
    }

}

func CreateRecentItem(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserID: String) {
    
    // generating autoID
    let ref = firebase.child("Recent").childByAutoId()
    
    // generated key
    let recentId = ref.key
    // getting current date
    let date = dateFormatter().stringFromDate(NSDate())
    
    let recent = ["recentId": recentId, "userId": userId, "chatRoomID": chatRoomID, "members": members, "withUserUsername": withUserUsername, "lastMessage": "", "counter": 0, "date": date, "withUserUserId": withUserUserID]
    
    // save to firebase
    ref.setValue(recent) { (error: NSError?, ref: FIRDatabaseReference) in
        if error != nil {
            print("error creating recent \(error)")
        }
    }
    
}

// MARK: Update Recent

func UpdateRecents(chatRoomID: String, lastMessage: String) {
    firebase.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
        
        if snapshot.exists() {
            for recent in snapshot.value!.allValues {
                // update recent
                UpdateRecentItem(recent as! NSDictionary, lastMessage: lastMessage)
            }
        }
    }
}

func UpdateRecentItem(recent: NSDictionary, lastMessage: String) {
    
    // using the current date
    let date = dateFormatter().stringFromDate(NSDate())
    
    var counter = recent["counter"] as! Int
    
    if recent["userId"] as? String != currentUser.objectId {
        counter += 1
    }
    
    let values = ["lastMessage" : lastMessage, "counter": counter, "date": date]
    
    firebase.child("Recent").child(recent["recentId"] as! String).updateChildValues(values as [NSObject : AnyObject]) { (error:NSError?, ref: FIRDatabaseReference) in
        
        if error != nil{
            print("Error couldn't update recent item -> \(error)")
        }
    }
}

// MARK: Restart Recent Chat
func RestartRecentChat(recent: NSDictionary) {
    
    for userId in recent["members"] as! [String] {
        
        if userId != currentUser.objectId {
            
            CreateRecent(userId, chatRoomID: (recent["chatRoomID"] as? String)!, members: (recent["members"] as! [String]), withUserUsername: currentUser.name, withUserUserId: currentUser.objectId)
        }
    }
}

// MARK: Delete Recent functions

func DeleteRecentItem(recent: NSDictionary) {
    
    firebase.child("Recent").child((recent["recentId"] as? String)!).removeValueWithCompletionBlock { (error:NSError?, ref:FIRDatabaseReference) in
        if error != nil {
            print("Error deleting recent item: \(error)")
        }
    }
}

// MARK:- Helper Functions

private let dateFormat = "yyyyMMddHHmmss"

// universal dateFormat: textual representation of date and time
func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}