//
//  Message.swift
//  UBookIt
//
//  Created by apple on 8/2/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Message {
    var key: String?
    let content: String
    let timestamp: Date
    let sender: User
    var dictValue:[String:Any] {
        let userDict = ["name":sender.name,
                        "uid":sender.uid,
                        "zip":sender.zip]
        return ["sender":userDict,
                "content":content,
                "timestamp":timestamp.timeIntervalSince1970]
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let zip = userDict["zipcode"] as? String,
            let name = userDict["name"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.content = content
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.sender = User(uid: uid, zip: zip, name: name)
    }
    
    init(content:String) {
        self.content = content
        self.timestamp = Date()
        self.sender = User.current
    }
}
