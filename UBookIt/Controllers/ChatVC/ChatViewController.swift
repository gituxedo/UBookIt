//
//  ChatViewController.swift
//  UBookIt
//
//  Created by apple on 7/28/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController, SBDConnectionDelegate, SBDChannelDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func initViewController() {
        // ...
        SBDMain.add(self as SBDChannelDelegate, identifier: "UNIQUE_HANDLER_ID")
        // ...
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        // Received a chat message
    }
    
    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        // When read receipt has been updated
    }
    
    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
        // When typing status has been updated
    }
    
    func channel(_ sender: SBDGroupChannel, userDidJoin user: SBDUser) {
        // When a new member joined the group channel
    }
    
    func channel(_ sender: SBDGroupChannel, userDidLeave user: SBDUser) {
        // When a member left the group channel
    }
    
    func channel(_ sender: SBDOpenChannel, userDidEnter user: SBDUser) {
        // When a new user entered the open channel
    }
    
    func channel(_ sender: SBDOpenChannel, userDidExit user: SBDUser) {
        // When a new user left the open channel
    }
    
    func channel(_ sender: SBDOpenChannel, userWasMuted user: SBDUser) {
        // When a user is muted on the open channel
    }
    
    func channel(_ sender: SBDOpenChannel, userWasUnmuted user: SBDUser) {
        // When a user is unmuted on the open channel
    }
    
    func channel(_ sender: SBDOpenChannel, userWasBanned user: SBDUser) {
        // When a user is banned on the open channel
    }
    
    func channel(_ sender: SBDOpenChannel, userWasUnbanned user: SBDUser) {
        // When a user is unbanned on the open channel
    }
    
    func channelWasFrozen(_ sender: SBDOpenChannel) {
        // When the open channel is frozen
    }
    
    func channelWasUnfrozen(_ sender: SBDOpenChannel) {
        // When the open channel is unfrozen
    }
    
    func channelWasChanged(_ sender: SBDBaseChannel) {
        // When a channel property has been changed
    }
    
    func channelWasDeleted(_ channelUrl: String, channelType: SBDChannelType) {
        // When a channel has been deleted
    }
    
    func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
        // When a message has been deleted
    }
    
    func didStartReconnection() {
        // Network has been disconnected. Auto reconnecting starts
    }
    
    func didSucceedReconnection() {
        // Auto reconnecting succeeded
    }
    
    func didFailReconnection() {
        // Auto reconnecting failed. You should call `connect` to reconnect to SendBird.
    }
}
