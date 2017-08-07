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
        if let _ = error {}
        guard let user = user
            else {return}
        UserService.show(forUID: user.uid) {(user) in
            if let user = user {
                //handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                let storyboard = UIStoryboard(name: "Choice", bundle: Bundle.main)
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                //handle new user
                self.performSegue(withIdentifier: "toZip", sender: self)
            }
        }
    }
}
