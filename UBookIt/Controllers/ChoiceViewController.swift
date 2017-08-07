//
//  ChoiceViewController.swift
//  UBookIt
//
//  Created by apple on 7/14/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ChoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var authHandle: AuthStateDidChangeListenerHandle?
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            let loginViewController = UIStoryboard.initialViewController(for: .Login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
//    deinit {
//        if let authHandle = authHandle {
//            Auth.auth().removeStateDidChangeListener(authHandle)
//        }
//    }
    @IBAction func logOutButton(_ sender: UIButton) {
        
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
                do {
                    try Auth.auth().signOut()
                    print("log out user")
                } catch let error as NSError {
                    assertionFailure("Error signing out: \(error.localizedDescription)")
                }
            }
            alertController.addAction(signOutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
    }
    
    @IBAction func unwindToChoiceViewController(_ segue: UIStoryboardSegue) {
        //perform actions later
        if segue.identifier == "cancel" {
            print("tapped cancel")
        } else if segue.identifier == "post" {
            
            print("posted")
        } else {
            print("back from search")
        }
    }
}
