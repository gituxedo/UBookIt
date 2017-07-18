//
//  ListingViewController.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit

class ListingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var conditionPicker: UIPickerView!
    var pickerData:[String] = []
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var extraNotesTextView: UITextView!
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        ListingService.create(title: titleTextField.text!, author: authorTextField.text!, condition: pickerData[conditionPicker.selectedRow(inComponent: 0)], edition: editionTextField.text!, price: Double(priceTextField.text!)!, extra: extraNotesTextView.text)
    }
    
    @IBAction func postListing(_ segue: UIStoryboardSegue) {
        if segue.identifier == "post" {
            ListingService.create(title: titleTextField.text!, author: authorTextField.text!, condition: pickerData[conditionPicker.selectedRow(inComponent: 0)], edition: editionTextField.text!, price: Double(priceTextField.text!)!, extra: extraNotesTextView.text)
            print("posted")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conditionPicker.delegate = self
        self.conditionPicker.dataSource = self
        pickerData = ["Perfect", "Like New", "Good", "Fair", "Poor"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
