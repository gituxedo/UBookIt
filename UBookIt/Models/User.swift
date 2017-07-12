//
//  User.swift
//  UBookIt
//
//  Created by apple on 7/11/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import GoogleMaps

class User {
    
    // MARK: - Properties
    
    let uid: String
    let name: String
    let location: CLLocationCoordinate2D
    
    // MARK: - Init
    
    init(uid: String, name: String, location: CLLocation) {
        self.uid = uid
        self.name = name
        self.location = location.coordinate
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
            let location = dict["location"] as? CLLocation
            else { return nil }
        
        self.uid = snapshot.key
        self.name = name
        self.location = location.coordinate
    }
}
