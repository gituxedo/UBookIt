//
//  SearchViewController.swift
//  UBookIt
//
//  Created by apple on 7/12/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class SearchViewController:UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var bookTableView: UITableView!
    var zip:String = User.current.zip
    var listings:[Listing] = []
    //firebase_node.once('value', function(snapshot) { alert('Count: ' + snapshot.numChildren()); });

//    for 0..<Database.database().reference().child("zipcodes").child(zip).numChildren()
    var titles:[String] = []
    var bookSearchResults:Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                self.bookTableView.delegate = self
                self.bookTableView.dataSource = self
        UserService.posts(user: User.current) { (listings) in
            self.listings = listings
            self.bookTableView.reloadData()
            print("listings: \(listings)")
            
        }
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
        print(listings.count)
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListingCell
        configureCell(cell: cell, listing: listings[indexPath.row])
        
        return cell
    }
    
    func configureCell(cell:ListingCell, listing:Listing) {
        cell.titleLabel.text = listing.title.capitalized
        cell.conditionLabel.text = "Condition: "+listing.condition
        cell.editionLabel.text = "Edition: " + listing.edition
        cell.priceLabel.text = "Price: \n $" + String(format: "%.2f", listing.price)
    }
}

