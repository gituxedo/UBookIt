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
    static func create(title:String, author:String, condition:String, edition:String, price:Double, imgURL:String, extra:String?) {
        let currentUser = User.current
        let listing = Listing(title:title, author:author, condition:condition, edition:edition, price:price, imageURL: "", extra:extra)
        let listRef = Database.database().reference().child("listings").child(currentUser.uid).childByAutoId()
        let dict = listing.dictValue
        listRef.setValue(dict)
        let listingKey = listRef.key
        let zipRef = Database.database().reference().child("zipcodes").child(currentUser.zip).child(listingKey)
        zipRef.setValue(dict)
        zipRef.updateChildValues(dict)
        
    }
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {return}
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
//            create(forURLString: urlString, aspectHeight: aspectHeight)
            print("image url: \(urlString)")
        }
    }
}
