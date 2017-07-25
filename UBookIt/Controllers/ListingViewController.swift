//
//  ListingViewController.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class ListingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let photoHelper = PhotoHelper()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var conditionPicker: UIPickerView!
    var pickerData:[String] = []
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var extraNotesTextView: UITextView!
    
    @IBAction func uploadPhotoTapped(_ sender: UIButton) {
            photoHelper.presentActionSheet(from: self)
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let author = authorTextField.text,
            let edition = editionTextField.text,
            let price = Double(priceTextField.text!) else {
                let fillPopup = UIAlertController(title: "Cannot post", message: "Please complete all fields!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
                    print("tapped \(action.title!)")
                })
                fillPopup.addAction(ok)
                self.present(fillPopup, animated: true, completion: {return})
                return
            }
                    
        ListingService.create(title: title, author: author, condition: pickerData[conditionPicker.selectedRow(inComponent: 0)], edition: edition, price: price, imgURL: "", extra: extraNotesTextView.text)
    }
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    @IBAction func postListing(_ segue: UIStoryboardSegue) {
        guard let title = titleTextField.text,
            let author = authorTextField.text,
            let edition = editionTextField.text,
            let price = Double(priceTextField.text!) else {
                let fillPopup = UIAlertController(title: "Cannot post", message: "Please complete all fields!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
                    print("tapped \(action.title!)")
                })
                fillPopup.addAction(ok)
                self.present(fillPopup, animated: true, completion: {return})
                return
            }
        ListingService.create(title: title, author: author, condition: pickerData[conditionPicker.selectedRow(inComponent: 0)], edition: edition, price: price, imgURL: "", extra: extraNotesTextView.text)
        performSegue(withIdentifier: "post", sender: self)
        print("posted \(titleTextField.text ?? "")")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conditionPicker.delegate = self
        self.conditionPicker.dataSource = self
        pickerData = ["Perfect", "Like New", "Good", "Fair", "Poor"]
        self.hideKeyboard()
        photoHelper.completionHandler = {(image) in
            StorageService.uploadImage(image, at: StorageReference.newPostImageReference(), completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {return}
                let urlString = downloadURL.absoluteString
                
                print("imgURL: \(urlString)")
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        conditionPicker.selectRow(1, inComponent: 0, animated: false)
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

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
