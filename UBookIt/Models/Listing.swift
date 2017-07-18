//
//  Listing.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

protocol UKeyed {
    var key:String? {get set}
    var extra:String? {get set}
}
class Listing:UKeyed {
    var key: String?
    let creationDate: Date
    let poster: User
    let title: String
    let author: String
    let condition: String
    let edition: String
    let price: Double
    var extra: String?
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid,
                        "zip" : poster.zip]
        return ["title" : title,
                "author" : author,
                "condition" : condition,
                "edition" : edition,
                "price" : price,
                "extra" : extra ?? "",
                "created_at" : createdAgo,
                "poster" : userDict]
    }
    
    init(title:String, author:String, condition:String, edition:String, price:Double, extra: String?) {
        self.title = title
        self.author = author
        self.condition = condition
        self.edition = edition
        self.price = price
        self.poster = User.current
        self.extra = extra ?? ""
        self.creationDate = Date()
        
    }
    
    init?(snapshot:DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any],
            let title = dict["title"] as? String,
            let author = dict["author"] as? String,
            let condition = dict["condition"] as? String,
            let edition = dict["edition"] as? String,
            let price = dict["price"] as? Double,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let userDict = dict["poster"] as? [String:Any],
            let uid = userDict["uid"] as? String,
            let zip = userDict["zip"] as? String,
            let extra = dict["extra"] as? String?
        else {return nil}
        
        self.title = title
        self.author = author
        self.condition = condition
        self.edition = edition
        self.price = price
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.poster = User(uid: uid, zip: zip)
        self.extra = extra ?? ""
    }
}
