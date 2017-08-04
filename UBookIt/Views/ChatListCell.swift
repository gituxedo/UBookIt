//
//  ChatListCell.swift
//  UBookIt
//
//  Created by apple on 8/3/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        print("dismissed")
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
