//
//  ListingTableViewCell.swift
//  UBookIt
//
//  Created by apple on 7/17/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit

class ListingCell:UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func buyButton(_ sender: UIButton) {
        //send to PM/SMS text screen
        print("I want to buy \(titleLabel.text ?? "") for $\(priceLabel.text ?? "")!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
}
