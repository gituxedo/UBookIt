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
import GoogleMaps

struct UserService {
//    static func create(_ firUser: FIRUser, location: CLLocation, completion: @escaping (User?) -> Void) {
//        let userAttrs = ["location": location]
//        
//        let ref = Database.database().reference().child("users").child(firUser.uid)
//        ref.setValue(userAttrs) { (error, ref) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//                return completion(nil)
//            }
//            
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                let user = User(snapshot: snapshot)
//                completion(user)
//            })
//        }
//    }
    
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
