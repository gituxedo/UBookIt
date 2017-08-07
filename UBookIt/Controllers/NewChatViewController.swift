//
//  NewChatViewController.swift
//  UBookIt
//
//  Created by apple on 8/3/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var following = [User]()
    var selectedUser: User?
    var existingChat: Chat?

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        tableView.tableFooterView = UIView()
        following.append(User.current)
//        following.append(<#T##newElement: User##User#>)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        guard let selectedUser = selectedUser else {return}
        sender.isEnabled = false
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            sender.isEnabled = true
            self.existingChat = chat
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
        print("nextbutton tapped")
    }

}

extension NewChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatUserCell") as! NewChatUserCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: NewChatUserCell, at indexPath: IndexPath) {
        let follower = following[indexPath.row]
        cell.textLabel?.text = follower.name
        
        if let selectedUser = selectedUser, selectedUser.uid == follower.uid {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension NewChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedUser = following[indexPath.row]
        cell.accessoryType = .checkmark
        nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 4
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // 5
        cell.accessoryType = .none
    }
}
