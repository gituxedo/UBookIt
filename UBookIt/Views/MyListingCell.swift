//
//  MyListingCell.swift
//  UBookIt
//
//  Created by apple on 8/8/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit

class MyListingCell:UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
