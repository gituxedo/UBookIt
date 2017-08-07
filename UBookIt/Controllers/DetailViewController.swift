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
    @IBOutlet weak var bookLargeImageView: UIImageView!
    
    var listing:Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "$" + String(format: "%.2f", (listing?.price)!)
        titleLabel.text = listing?.title.capitalized
        authorLabel.text = listing?.author
        editionLabel.text = listing?.edition
        conditionLabel.text = listing?.condition
        extraLabel.text = listing?.extra ?? "None"
        let imageURL = URL(string: (listing?.imgURL)!)
        bookLargeImageView.kf.setImage(with: imageURL)
        
//        UserService.posts(user: User.current) { (listing) in
//            self.listing = listing
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            priceLabel.text = "$" + String(format: "%.2f", (listing?.price)!)
            titleLabel.text = listing?.title
            authorLabel.text = listing?.author
            editionLabel.text = listing?.edition
            conditionLabel.text = listing?.condition
            extraLabel.text = listing?.extra ?? "None"
            
            print("listing details shown")
        }
    }
}
