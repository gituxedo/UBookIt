//
//  ZipViewController.swift
//  UBookIt
//
//  Created by apple on 7/13/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ZipViewController: UIViewController {
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let zip = zipTextField.text,
            !zip.isEmpty else { return }
        UserService.create(firUser, zipcode: zip) { (user) in
            guard let user = user else { return }
            User.setCurrent(user, writeToUserDefaults: true)
            print("Created new user: \(user.uid)")
//            let initialViewController = UIStoryboard.initialViewController(for: .location)
//            self.view.window?.rootViewController = initialViewController
//            self.view.window?.makeKeyAndVisible()
        }
    }
}
