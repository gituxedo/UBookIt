//
//  YourTextbooksViewController.swift
//  UBookIt
//
//  Created by apple on 8/8/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher

class YourTextbooksViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var bookTableView: UITableView!
    
    var myListings:[Listing] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookTableView.delegate = self
        self.bookTableView.dataSource = self
        bookTableView.tableFooterView = UIView()
        
        UserService.ownPosts(user: User.current) { (myListings) in
            self.myListings = myListings
            self.bookTableView.reloadData()
            print("my listings: \(myListings)")
        }
    }
    
    @IBAction func unwindToYourTextbooksVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            if id == "myDetail" {
                let indexPath = bookTableView.indexPathForSelectedRow!
                let listing:Listing
                listing = myListings[indexPath.row]
                let myDetailViewController = segue.destination as! MyDetailViewController
                myDetailViewController.listing = listing
                myDetailViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "myDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        }; cell.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let rootRef = Database.database().reference()
        if editingStyle == .delete {
            let zipRef = rootRef.child("zipcodes/\(User.current.zip)/\(myListings[indexPath.row].key!)")
            zipRef.setValue(nil)
            let postRef = rootRef.child("listings/\(User.current.uid)/\(myListings[indexPath.row].key!)")
            postRef.setValue(nil)
            myListings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.bookTableView.reloadData()
        }
    }

}

extension YourTextbooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyListingCell
        configureCell(cell: cell, listing: myListings[indexPath.row])
        return cell
    }
    
    func configureCell(cell: MyListingCell, listing:Listing) {
        let imageURL = URL(string: listing.imgURL)
        cell.bookImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = listing.title.capitalized
        cell.conditionLabel.text = "Condition: "+listing.condition
        cell.editionLabel.text = "Edition: " + listing.edition
        cell.priceLabel.text = "Price: \n$" + String(format: "%.2f", listing.price)
    }
}
