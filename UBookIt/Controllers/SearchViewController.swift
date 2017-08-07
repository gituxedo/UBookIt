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
    
    static var listings:[Listing] = []
    var indices:[IndexPath] = []
    var bookSearchResults:[Listing]?
    var shouldShowResults = false
    var searchController: UISearchController!
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
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
        if let id = segue.identifier {
            if id == "detail" {
                let indexPath = bookTableView.indexPathForSelectedRow!
                let listing:Listing
                if searchController.isActive && searchController.searchBar.text != "" {
                    listing = (bookSearchResults?[indexPath.row])!
                } else {
                    listing = SearchViewController.listings[indexPath.row]
                }
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.listing = listing
                detailViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        }; cell.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let ref = Database.database().reference().child("listings/\(User.current.uid)")
        if editingStyle == .delete {
            if User.current.uid == SearchViewController.listings[indexPath.row].poster.uid {
                let postRef = ref.child(SearchViewController.listings[indexPath.row].key!)
                postRef.setValue(nil)
                let zipRef = Database.database().reference().child("zipcodes/\(User.current.zip)/\(SearchViewController.listings[indexPath.row].key!)")
                zipRef.setValue(nil)
                SearchViewController.listings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.bookTableView.reloadData()
            } else {
                let denyPopup = UIAlertController(title: "Cannot delete", message: "You cannot delete other users' listings!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Got it!", style: .default) { (action) in
                    print("tapped: \(action.title!)")
                }
                denyPopup.addAction(ok)
                self.present(denyPopup, animated: true, completion: {return})
            }
        }
    }

    //MARK: - Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        // Filter the array
        self.bookSearchResults = SearchViewController.listings.filter({(book:Listing) -> Bool in
            
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
        cell.priceLabel.text = "Price: \n$" + String(format: "%.2f", listing.price)
    }
}

