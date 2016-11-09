//
//  RecentViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-02.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChooseUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UITableviewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell?.bindData(recent)
        
        return cell!
    }
    
    // MARK: UITableViewDelegate functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let  recent = recents[indexPath.row]
        
        // create recent for user2
        RestartRecentChat(recent)
        
        performSegueWithIdentifier("recentToChatSeg", sender: indexPath)
    }
    
    // to edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // to delete the recent tableView
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let recent = recents[indexPath.row]
        
        // remove recent from array
        recents.removeAtIndex(indexPath.row)
        
        // delete recent from firebase
        DeleteRecentItem(recent)
        
        tableView.reloadData()
    }

    //MARK:- IBActions
    @IBAction func startNewChatPressed(sender: AnyObject) {
        performSegueWithIdentifier("recentToChooseUserVC", sender: self)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "recentToChooseUserVC" {
            let vc = segue.destinationViewController as! ChooseUserViewController
            vc.delegate = self
            
        }
        
        if segue.identifier == "recentToChatSeg" {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            
            let recent = recents[indexPath.row]
            
            chatVC.recent = recent
            
            chatVC.chatRoomId = recent["chatRoomID"] as? String
        }
    }
    
    // MARK: ChooseUserDelegate
    func createChatRoom(withUser: BackendlessUser) {
        
        let chatVC = ChatViewController()
        
        // hide the bottom bar
        chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)
        
        chatVC.withUser = withUser
        chatVC.chatRoomId = startChat(currentUser, user2: withUser)
    }
    
    //MARK: Load recents from firebase
    
    func loadRecents()
    {
        
        // looking at the recent database where it is equal to current userID
        // .Value observes all value in the dataBase
        firebase.child("Recent").queryOrderedByChild("userId").queryEqualToValue(backendless.userService.currentUser.objectId).observeEventType(.Value) { (snapshot:FIRDataSnapshot) in
        
            self.recents.removeAll()
            
            if snapshot.exists()
            {
                
                // getting the latest date first
                let sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                
                for recent in sorted
                {
                    self.recents.append(recent as! NSDictionary)
                    
                    // add function to have offline access as well
//                    firebase.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(recent["chatRoomID"]).observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
//                    
//                    })
                }
            }
            
            self.tableView.reloadData()
        }

    }
    
    
}
