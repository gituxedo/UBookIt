//
//  LoginViewController.swift
//  UBookIt
//
//  Created by apple on 7/10/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        // add google+fb providers
        let providers: [FUIAuthProvider] = [FUIFacebookAuth(), FUIGoogleAuth()]
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        if let user = Auth.auth().currentUser {
            //handle existing user
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot) {
                    print("Welcome back, \(user.name).")
                } else {
                    print("New user!")
                    self.performSegue(withIdentifier: "toLocation", sender: self)
                }
            })
//            let initialViewController = UIStoryboard.initialViewController(for: .main)
//            self.view.window?.rootViewController = initialViewController
//            self.view.window?.makeKeyAndVisible()
        } else {
            //handle new user
            self.performSegue(withIdentifier: "toLocation", sender: self)
        }
    }
}
