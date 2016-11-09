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
    
    var initialLoadComplete: Bool = false
    
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
        loadMessages()
        
        self.inputToolbar.contentView.textView.placeHolder = "New Message"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: JSQMessages dataSource function
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            cell.textView.textColor = UIColor.whiteColor()
        } else {
            cell.textView.textColor = UIColor.blackColor()
        }
        
        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messages[indexPath.row]
        
        return data
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        // color of the messages
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            
            return outgoingBubble
            
        } else {
            
            return incomingBubble
        }
        
    }
    
    //MARK: JSQMessages Delegate function
    
    // Send button pressed
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if text != "" {
            
            sendMessage(text, date: date, picture: nil, location: nil)
        }
    }
    
    // attachment button pressed
    override func didPressAccessoryButton(sender: UIButton!) {
        
        print("Accessory Button pressed")
    }
    
    //MARK: Send message
    
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        var outgoingMessage = OutgoingMessage?()
        
        // if text message
        if let text = text {
            // send text message
            
            outgoingMessage = OutgoingMessage(message: text, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Delivered", type: "text")
        }
        
        // send picture message
        if let pic = picture {
            // send picture message
        }
        
        if let loc = location {
            // send location message
        }
        
        // play message send sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        outgoingMessage!.sendMessage(chatRoomId, item: outgoingMessage!.messageDictionary)
        
    }
    
    func loadMessages() {
        
        ref.child(chatRoomId).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            // get dictionaries
            // create JSQ messages
            
            self.insertMessages()
            self.finishReceivingMessageAnimated(true)
            self.initialLoadComplete = true
        }
        
        // if a new there is a new message, it is called
        ref.child(chatRoomId).observeEventType(.ChildAdded) { (snapshot:FIRDataSnapshot) in
            
            if snapshot.exists() {
                
                let item = (snapshot.value as? NSDictionary)!
                
                if self.initialLoadComplete {
                    let incoming = self.insertMessage(item)
                    if incoming {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    
                    self.finishSendingMessageAnimated(true)
                } else {
                    
                    // add each dictionary to loaded array
                    self.loaded.append(item)
                }
                
            }
        }
        
        ref.child(chatRoomId).observeEventType(.ChildChanged) { (snapshot: FIRDataSnapshot) in
            
            // updated message
        }
        
        ref.child(chatRoomId).observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            
            // deleted message
        }
        
    }
    
    func insertMessages() {
        
        for item in loaded {
            
            // create message
            insertMessage(item)
        }
    }
    
    func insertMessage(item: NSDictionary) -> Bool {
        
        let incomingMessage = IncomingMessage(collectionView_: self.collectionView!)
        
        let message = incomingMessage.createMessage(item)
        
        objects.append(item)
        messages.append(message!)
        
        return incoming(item)
    }
    
    func incoming(item: NSDictionary) -> Bool {
        
        if self.senderId == item["senderId"] as! String {
            return false
        } else {
            return true
        }
    }
    
    func outgoing(item: NSDictionary) -> Bool {
        
        if self.senderId == item["senderId"] as! String {
            return true
        } else {
            return false
        }
    }
    
}
