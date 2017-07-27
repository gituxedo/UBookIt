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

class SearchViewController:UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var bookTableView: UITableView!
//    var zip:String = User.current.zip
    static var listings:[Listing] = []
    var bookSearchResults:[Listing]?
    var shouldShowResults = false
    var searchController: UISearchController!
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        //only declaration is needed
    }
    
    @IBAction func postListing(_ segue: UIStoryboardSegue) {
        //declaration here
        //postListing in other class does nothing
        //save listing to firebase here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bookTableView.delegate = self
        self.bookTableView.dataSource = self
        UserService.posts(user: User.current) { (listings) in
            SearchViewController.listings = listings
            self.bookTableView.reloadData()
            print("listings: \(listings)")
            
            self.configureSearchController()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listing:Listing
        if (segue.identifier != nil) && segue.identifier == "detail" {
            let indexPath = bookTableView.indexPathForSelectedRow!
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.listing = SearchViewController.listings[indexPath.row]
        }
    }
    
    //MARK: - tableView methods
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

    //MARK: - searchBar methods
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        // Filter the array
        self.bookSearchResults = SearchViewController.listings.filter({(book:Listing) -> Bool in
            print(searchString ?? "foo")
            return book.title.lowercased().range(of: (searchString?.lowercased())!) != nil
        })
        bookTableView.reloadData()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for titles here..."
        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
        bookTableView.tableHeaderView = searchController.searchBar
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        shouldShowResults = false
//    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowResults = true
        bookTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowResults = false
        bookTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowResults {
            shouldShowResults = true
            bookTableView.reloadData()
        }
    }
}

extension SearchViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowResults {
            return bookSearchResults?.count ?? 0
        } else {
            return SearchViewController.listings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListingCell
        if shouldShowResults {
            print ("booksearchResults: \(indexPath.row)")
            configureCell(cell: cell, listing: (bookSearchResults?[indexPath.row])!)
        } else {
            print ("listings: \(indexPath.row)")
            configureCell(cell: cell, listing: SearchViewController.listings[indexPath.row])
        }
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

