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

class ListingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let photoHelper = PhotoHelper()
    var imgURL = ""
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var conditionPicker: UIPickerView!
    var pickerData:[String] = []
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var extraNotesTextView: UITextView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = self.titleTextField.text,
            let author = self.authorTextField.text,
            let edition = self.editionTextField.text,
            let price = Double(self.priceTextField.text!),
            let _ = self.bookImageView.image,
            extraNotesTextView.text != nil,
            extraNotesTextView.text != "Input your preferred method of contact here"
            else {
                let fillPopup = UIAlertController(title: "Cannot post", message: "Please complete all fields!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
                    print("tapped \(action.title!)")
                })
                fillPopup.addAction(ok)
                self.present(fillPopup, animated: true, completion: {return})
                return
            }
        
        let confirmPopup = UIAlertController(title: "Post", message: "Are you sure you want to post this listing?", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            print("posted: \(action.title!)")
            ListingService.create(title: title, author: author, condition: self.pickerData[self.conditionPicker.selectedRow(inComponent: 0)], edition: edition, price: price, imgURL: self.imgURL, extra: self.extraNotesTextView.text)
            print("imgURL: \(self.imgURL)")
            self.performSegue(withIdentifier: "didPost", sender: self)
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            print("tapped \(action.title!)")
        })
        confirmPopup.addAction(cancel)
        confirmPopup.addAction(ok)
        self.present(confirmPopup, animated: true, completion: {return})
        return
    }
    
    @IBAction func uploadPhotoTapped(_ sender: UIButton) {
            photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conditionPicker.delegate = self
        self.conditionPicker.dataSource = self
        self.extraNotesTextView.delegate = self
        pickerData = ["Perfect", "Like New", "Good", "Fair", "Poor"]
        postButton.isEnabled = false
        self.hideKeyboard()
        extraNotesTextView.text = "Input your preferred method of contact here"
        extraNotesTextView.textColor = UIColor.lightGray
        photoHelper.completionHandler = {(image) in
            
            StorageService.uploadImage(image, at: StorageReference.newPostImageReference(), completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {return}
                let urlString = downloadURL.absoluteString
                self.imgURL = urlString
                self.bookImageView.image = image
                self.postButton.isEnabled = true
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Input your preferred method of contact here"
            textView.textColor = UIColor.lightGray
        }
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerData[row]
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
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
