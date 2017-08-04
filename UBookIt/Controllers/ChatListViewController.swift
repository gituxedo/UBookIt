//
//  ChatListViewController.swift
//  UBookIt
//
//  Created by apple on 8/3/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatListViewController: UIViewController {
    
    var chats = [Chat]()
    var userChatsHandle:DatabaseHandle = 0
    var userChatsRef: DatabaseReference?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 71
        tableView.tableFooterView = UIView()
        
        userChatsHandle = UserService.observeChats{ [weak self](ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    deinit {
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated:true)
    }
    
    // MARK: - IBOutlets
    
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        
        let chat = chats[indexPath.row]
        cell.titleLabel.text = chat.title
        cell.lastMessageLabel.text = chat.lastMessage
        
        return cell
    }
}
