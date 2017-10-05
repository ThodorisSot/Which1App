//
//  UsersViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 26/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UISearchResultsUpdating ,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var tableView: UITableView!
    
    var user = [User]()
    
    //search
    var filteredUser = [User]()
    var resultsSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveUsers()
        
        //search
        self.resultsSearchController = UISearchController(searchResultsController: nil)
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.dimsBackgroundDuringPresentation = false
        self.resultsSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultsSearchController.searchBar
        self.tableView.reloadData()
        
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
        
        if self.resultsSearchController.isActive {
            cell.nameLabel.text = self.filteredUser[indexPath.row].fullName
            cell.userID = self.filteredUser[indexPath.row].userID
            cell.userImage.loadImageUsingCacheWithUrlString(self.filteredUser[indexPath.row].imagePath!)
            //self.user = self.filteredUser
            checkFollowing(indexPath: indexPath)
        }
        else{
            cell.nameLabel.text = self.user[indexPath.row].fullName
            cell.userID = self.user[indexPath.row].userID
            cell.userImage.loadImageUsingCacheWithUrlString(self.user[indexPath.row].imagePath!)
            checkFollowing(indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultsSearchController.isActive {
            return self.filteredUser.count
            
        }
        else {
            return user.count ?? 0
            }
        
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //self.filteredUser.removeAll(keepingCapacity: false)
        if searchController.searchBar.text! == "" {
            filteredUser = user
        } else {
        
    
        filteredUser = user.filter {
            $0.fullName.lowercased().contains(searchController.searchBar.text!.lowercased())
            
            
        }
        }
        
        
        //let searchTerm = searchController.searchBar.text!
        //let array = filteredUser.filter {result in return result.fullName.contains(searchTerm)}
        //let searchPredicate = NSPredicate(format: "LIKE[cd] %@", searchController.searchBar.text!)
        //let array = (self.user as NSArray).filtered(using: searchPredicate)
        //self.filteredUser = array as! [User]
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following
                
                {
                        if value as! String == self.user[indexPath.row].userID {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                        
                        }
                    }
                }
            
                
            if !isFollower {
               
                    let following = ["following/\(key)" : self.user[indexPath.row].userID]
                    let followers = ["followers/\(key)" : uid]
                    
                    ref.child("users").child(uid).updateChildValues(following)
                    ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
                    
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
            }
        
            
             })
        ref.removeAllObservers()
        
    }
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following
                {
                    
                    //if self.resultsSearchController.isActive {
                        //self.user = self.filteredUser
                    //}
                    
                        if value as! String == self.user[indexPath.row].userID {
                            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                                                                                }
                        }
                    }
                    
            
        
        })
        ref.removeAllObservers()
        
    }
    
    
    
    

    
    
    @IBAction func logOutPressed(_ sender: Any) {
    }
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}
