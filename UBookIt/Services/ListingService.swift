//
//  ListingService.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct ListingService {
    //make private func??????
    static func create(title:String, author:String, condition:String, edition:String, price:Double, extra:String?) {
        let currentUser = User.current
        let listing = Listing(title:title, author:author, condition:condition, edition:edition, price:price, extra:extra)
        let listRef = Database.database().reference().child("listings").child(currentUser.uid).childByAutoId()
        let dict = listing.dictValue
        listRef.setValue(dict)
        let listingKey = listRef.key
        let zipRef = Database.database().reference().child("zipcodes").child(currentUser.zip).child(listingKey)
        zipRef.setValue(dict)
//        listRef.updateChildValues(dict)
        zipRef.updateChildValues(dict)
        
    }
}
