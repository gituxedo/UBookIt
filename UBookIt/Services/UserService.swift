//
//  UserService.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func posts(user: User, completion: @escaping ([Listing]) -> Void) {
        let ref = Database.database().reference().child("listings").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return completion([])}
            let listings:[Listing] = snapshot.reversed().flatMap {
                guard let listing = Listing(snapshot: $0)
                    else {return nil}
                return listing
            }
            completion(listings)
        })
    }
    
    static func create(_ firUser: FIRUser, zipcode: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["zipcode": zipcode]
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }

    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }; completion(user)
        })
    }
}
