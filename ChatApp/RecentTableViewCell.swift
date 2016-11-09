//
//  RecentTableViewCell.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-02.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let backendless = Backendless.sharedInstance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(recent: NSDictionary){
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.layer.masksToBounds = true
        
        self.avatarImageView.image = UIImage(named: "home")
        
        let withUserId = (recent.objectForKey("withUserUserId") as? String)!
        
        // get the backendless user and download avatar
        
        let whereClause = "objectId = '\(withUserId)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users:BackendlessCollection!) in
            
            let withUser = users.data.first as! BackendlessUser
            
            // use withUser to get avatar
            
        }) { (fault:Fault!) in
                print("error, could't get user avatar: \(fault)")
        }
        
        nameLbl.text = recent["withUserUsername"] as? String
        lastMessageLbl.text = recent["lastMessage"] as? String
        counterLbl.text = ""
        
        if (recent["counter"] as? Int)! != 0 {
            counterLbl.text = "\(recent["counter"]!) New"
        }
        
        let date = dateFormatter().dateFromString((recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSinceDate(date!)
        dateLbl.text = timeElipsed(seconds)
        
    }
    
    func timeElipsed(seconds: NSTimeInterval) -> String {
        let elapsed: String?
        
        if seconds < 60 {
            elapsed = "Just now"
        } else if (seconds < 60 * 60){
            let minutes = Int(seconds / 60)
            
            var minText = "min"
            if minutes > 1 {
                minText = "mins"
            }
            elapsed = "\(minutes) \(minText)"
            
        } else if (seconds < 24 * 60 * 60) {
            let hours = Int(seconds / (60 * 60))
            var hourText = "hour"
            if hours > 1 {
                hourText = "hours"
            }
            elapsed = "\(hours) \(hourText)"
        } else {
            let days = Int(seconds / (24 * 60 * 60))
            var dayText = "day"
            if days > 1 {
                dayText = "days"
            }
            elapsed = "\(days) \(dayText)"
        }
        
        return elapsed!
    }
}
