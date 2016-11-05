//
//  ChooseUserViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-03.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit

protocol ChooseUserDelegate {
    func createChatRoom(withUser: BackendlessUser)
}

class ChooseUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ChooseUserDelegate!
    
    var users: [BackendlessUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let user = users[indexPath.row]
        
        // the username displayed in the chat
        cell.textLabel?.text = user.name
        return cell
    }
    
    // MARK:- UITableViewDelegate
    
    // When the user taps on the tableViewCell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = users[indexPath.row]
        delegate.createChatRoom(user)
        
        
        // deselect when user taps on the cell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:- IBActions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        // cancel
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Load Backendless Users
    
    func loadUsers() {
        
        let whereClause = "objectId != '\(currentUser.objectId)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users: BackendlessCollection!) in
            
            self.users = users.data as! [BackendlessUser]
            
            self.tableView.reloadData()
            
            for user in users.data {
                let u = user as! BackendlessUser
                print(u.name)
            }
            
            
        }) { (fault:Fault!) in
                print("Error couldn't retrieve users: \(fault)")
        }
    }
}
