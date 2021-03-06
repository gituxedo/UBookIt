//
//  User.swift
//  UBookIt
//
//  Created by apple on 7/11/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User:NSObject {
    
    // MARK: - Properties
    
    let name: String
    let uid: String
    let zip: String
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }; return currentUser
    }
    
    // MARK: - Init
    
    init(uid: String, zip: String, name: String) {
        self.uid = uid
        self.zip = zip
        self.name = name
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let zip = dict["zipcode"] as? String,
            let name = dict["name"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.zip = zip
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let zip = aDecoder.decodeObject(forKey: Constants.UserDefaults.zip) as? String,
            let name = aDecoder.decodeObject(forKey: Constants.UserDefaults.name) as? String
            else { return nil }
        
        self.uid = uid
        self.zip = zip
        self.name = name
        
        super.init()
    }
    
    // MARK: - Class Methods
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }; _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(zip, forKey: Constants.UserDefaults.zip)
        aCoder.encode(name, forKey: Constants.UserDefaults.name)
    }
}

