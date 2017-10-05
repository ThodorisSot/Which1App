//
//  PreChatViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 29/03/2017.
//  Copyright © 2017 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class PreChatViewController: UIViewController, UISearchBarDelegate ,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var tableView: UITableView!
    
    private let CHAT_SEGUE = "ChatSegue";
    
    var user = [User]()
    //var filterUsers = [String]()
    
    //var searchController : UISearchController!
    //var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUsers()
        
        //self.resultsController.tableView.dataSource = self
        //self.resultsController.tableView.delegate = self
        
        //self.searchController = UISearchController(searchResultsController: self.resultsController)
        //self.tableView.tableHeaderView = self.searchController.searchBar
        //self.searchController.searchResultsUpdater = self
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func retrieveUsers() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = User()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
                            userToShow.fullName = fullName
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        //checkFollowing(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil);
    }
}
