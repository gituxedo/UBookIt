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
import Kingfisher

class SearchViewController:UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var bookTableView: UITableView!
    var zip:String = User.current.zip
    var listings:[Listing] = []
    var bookSearchResults:Array<String>?
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        //only declaration is needed
    }
    
    @IBAction func postListing(_ segue: UIStoryboardSegue) {
        //declaration here
        //postListing in other class does nothing
        //save lsiting to firebase here
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "detail" {
                let indexPath = bookTableView.indexPathForSelectedRow!
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.listing = listings[indexPath.row]
            }
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using filter method
//        if self.listings == nil {
//            self.bookSearchResults = nil
//            return
//        }
//        self.bookSearchResults = self.listings.filter({(aBook: String) -> Bool in
//            // to start, search by name
//            return aBook.range(of: searchText.lowercased()) != nil
//        })
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        self.performSegue(withIdentifier: "detail", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListingCell
        configureCell(cell: cell, listing: listings[indexPath.row])
        
        return cell
    }
    
    func configureCell(cell:ListingCell, listing:Listing) {
        let imageURL = URL(string: listing.imgURL)
        cell.bookImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = listing.title.capitalized
        cell.conditionLabel.text = "Condition: "+listing.condition
        cell.editionLabel.text = "Edition: " + listing.edition
        cell.priceLabel.text = "Price: \n $" + String(format: "%.2f", listing.price)
    }
}

