//
//  ProfileViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 09/01/2017.
//  Copyright © 2017 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var profiles = [Profile]()
    var display = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchProfile()
    }

    //make white bar style
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    //function to show user's only posts
    func fetchProfile() {
        
        let ref = FIRDatabase.database().reference()
        
        //ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
        
            //let users = snapshot.value as! [String : AnyObject]
            
            /*
            for (_,value) in users {
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                  */
                        self.display.append(FIRAuth.auth()!.currentUser!.uid)
                        

                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                        
                            let postsSnap = snap.value as! [String : AnyObject]
                        
                            for (_,profiles) in postsSnap {
                                if let userID = profiles["userID"] as? String {
                                    for each in self.display {
                                        if each == userID{
                                            
                                            let profileToShow = Profile()
                                    
                                            if let pathToImage1 = profiles["pathToImage1"] as? String,
                                            let pathToImage2 = profiles["pathToImage2"] as? String,
                                            let likes1 = profiles["likes1"] as? Int,
                                            let likes2 = profiles["likes2"] as? Int
                                            
                                            {
                                                profileToShow.pathToImage1 = pathToImage1
                                                profileToShow.pathToImage2 = pathToImage2
                                                profileToShow.likes1 = likes1
                                                profileToShow.likes2 = likes2
                                                profileToShow.userID = userID

                                                self.profiles.append(profileToShow)
                                            }
                                        }
                                    }
                                    self.collectionView.reloadData()
                }
                            }}
                        ) //}}
            
                                //}})
        ref.removeAllObservers()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCell
        
        cell.Image1.loadImageUsingCacheWithUrlString(self.profiles[indexPath.row].pathToImage1)
        cell.Image2.loadImageUsingCacheWithUrlString(self.profiles[indexPath.row].pathToImage2)
        //cell.authorLabel.text = self.posts[indexPath.row].author
        //cell.userImage.downloadImage(from: self.posts[indexPath.row].userImagePath)
        cell.likeLabel.text = "\(self.profiles[indexPath.row].likes1!) Likes"
        cell.like2Label.text = "\(self.profiles[indexPath.row].likes2!) Likes"
        //cell.postID = self.profiles[indexPath.row].postID
        
        
        return cell
    }
    
 
 
 }
