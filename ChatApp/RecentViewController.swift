//
//  RecentViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-02.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    //MARK:- IBActions
    @IBAction func startNewChatPressed(sender: AnyObject) {
        performSegueWithIdentifier("recentToChooseUserVC", sender: self)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "recentToChooseUserVC" {
            let vc = segue.destinationViewController as! ChooseUserViewController
        }
    }
    

}
