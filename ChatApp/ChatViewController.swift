//
//  ChatViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-04.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    let ref = firebase.child("Message")
    
    var messages: [JSQMessage] = []
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var withUser: BackendlessUser?
    var recent: NSDictionary?
    
    var chatRoomId: String!
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = currentUser.objectId
        self.senderDisplayName = currentUser.name
        
        // we dont want avatar
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        // load firebase messages
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
