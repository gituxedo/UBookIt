//
//  SearchViewController.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController:UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var bookTableView: UITableView!
    var listings:[Listing] = []
    var titles:[String] = []
    var bookSearchResults:Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
//        if self.listings == nil {
//            self.bookSearchResults = nil
//            return
//        }
//        self.bookSearchResults = self.listings.filter({(aBook: String) -> Bool in
//            // to start, let's just search by name
//            return aBook.range(of: searchText.lowercased()) != nil
//        })
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = .white
        }
    }
}

extension SearchViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListingCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ListingCell
        
        configureCell(cell: cell, listing: listings[indexPath.row])
        
        return cell
    }
    
    func configureCell(cell:ListingCell, listing:Listing) {
        cell.titleLabel.text = "Title: " + listing.title
        cell.conditionLabel.text = "Condition: "+listing.condition
        cell.editionLabel.text = "Edition: " + listing.edition
        cell.priceLabel.text = "Price: " + String(listing.price)
        
    }
}

