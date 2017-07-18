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

class ChoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
