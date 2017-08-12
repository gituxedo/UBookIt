//
//  DetailViewController.swift
//  UBookIt
//
//  Created by apple on 7/19/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var bookLargeImageView: UIImageView!
    
    var listing:Listing?
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        let contactPopup = UIAlertController(title: "Want to buy this book?", message: "Contact the seller!\n"+(listing?.extra)!, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Got it!", style: .default) { (action) in
        }
        contactPopup.addAction(ok)
        self.present(contactPopup, animated: true, completion: {return})
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let poster = listing!.poster
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if poster.uid != User.current.uid {
            let flagAction = UIAlertAction(title: "Report as Inappropriate", style: .default) { _ in
                ListingService.flag(self.listing!)
                
                let okAlert = UIAlertController(title: nil, message: "The post has been flagged.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
            }
            alertController.addAction(flagAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "$" + String(format: "%.2f", (listing?.price)!)
        titleLabel.text = listing?.title.capitalized
        authorLabel.text = listing?.author
        editionLabel.text = listing?.edition
        conditionLabel.text = listing?.condition
        posterLabel.text = listing?.poster.name
        extraLabel.text = listing?.extra ?? "None"
        let imageURL = URL(string: (listing?.imgURL)!)
        bookLargeImageView.kf.setImage(with: imageURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            priceLabel.text = "$" + String(format: "%.2f", (listing?.price)!)
            titleLabel.text = listing?.title
            authorLabel.text = listing?.author
            editionLabel.text = listing?.edition
            conditionLabel.text = listing?.condition
            extraLabel.text = listing?.extra ?? "None"
        }
    }
}
