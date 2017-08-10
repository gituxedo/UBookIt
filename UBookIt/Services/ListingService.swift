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
    static func create(title:String, author:String, condition:String, edition:String, price:Double, imgURL:String, extra:String) {
        let currentUser = User.current
        let listing = Listing(title:title, author:author, condition:condition, edition:edition, price:price, imageURL:imgURL, extra:extra)
        let listRef = Database.database().reference().child("listings/\(currentUser.uid)").childByAutoId()
        let dict = listing.dictValue
        listRef.setValue(dict)
        let listingKey = listRef.key
        let zipRef = Database.database().reference().child("zipcodes/\(currentUser.zip)").child(listingKey)
        zipRef.setValue(dict)
        zipRef.updateChildValues(dict)
    }
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {return}
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
    
    static func flag(_ listing: Listing) {
        guard let listingKey = listing.key else { return }
        let flaggedListingRef = Database.database().reference().child("flaggedlistings/\(listingKey)")
        let flaggedDict = ["image_url": listing.imgURL,
                           "poster_uid": listing.poster.uid,
                           "reporter_uid": User.current.uid]
        flaggedListingRef.updateChildValues(flaggedDict)
        
        let flagCountRef = flaggedListingRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            return TransactionResult.success(withValue: mutableData)
        })
    }
}
