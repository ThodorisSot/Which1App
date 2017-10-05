//
//  FeedViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 29/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet var collectionview: UICollectionView!
    
    var refresher: UIRefreshControl!
    
    //effects
    @IBOutlet var menuView: UIView!
    //@IBOutlet weak var visualEffectView: UIVisualEffectView!
   // var effect : UIVisualEffect!
    
    
    var posts = [Post]()
    var following = [String]()
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        menuView.layer.cornerRadius = 5
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to see whats new!")
        refresher.addTarget(self, action: #selector(FeedViewController.fetchPosts), for: UIControlEvents.valueChanged)
        collectionview.addSubview(refresher)
        
    }
    
    func animateIn(){
        self.view.addSubview(menuView)
        menuView.center = self.view.center
    
        menuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        menuView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.menuView.alpha = 1
            self.menuView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
           self.menuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.menuView.alpha = 0
            
        }) {(success:Bool) in self.menuView.removeFromSuperview()
        }
    }
    
    @IBAction func showView(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        animateOut()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    @IBAction func menuChat(_ sender: Any) {
        
        let messageController = MessagesController()
        
        self.messagesController?.fetchUserAndSetupNavBarTitle()
        
        //self.dismiss(animated: true, completion: nil)
        
        
        let navController = UINavigationController(rootViewController: messageController)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        
        
        let messageController = MessagesController()
            
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            //self.dismiss(animated: true, completion: nil)
            
            
            let navController = UINavigationController(rootViewController: messageController)
            present(navController, animated: true, completion: nil)
            
        }
        
        
        
    
    
    
    
    func fetchPosts(){
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            
            for (_,value) in users {
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String]{
                            for (_,user) in followingUsers{
                                self.following.append(user)
                            }
                        }
                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
                        
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            
                            
                            let postsSnap = snap.value as! [String : AnyObject]
                            
                            for (_,post) in postsSnap {
                                if let userID = post["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let posst = Post()
                                            if let author = post["author"] as? String,
                                                //let userImagePath = post["userImagePath"] as? String,
                                                let likes1 = post["likes1"] as? Int,
                                                let likes2 = post["likes2"] as? Int,
                                                let pathToImage1 = post["pathToImage1"] as? String,
                                                let pathToImage2 = post["pathToImage2"] as? String,
                                                let postID = post["postID"] as? String {
                                                
                                                posst.author = author
                                                //posst.userImagePath = userImagePath
                                                posst.likes1 = likes1
                                                posst.likes2 = likes2
                                                posst.pathToImage1 = pathToImage1
                                                posst.pathToImage2 = pathToImage2
                                                posst.postID = postID
                                                posst.userID = userID
                                                
                                                if let people = post["peopleWhoLike1"] as? [String : AnyObject] {
                                                    for (_,person) in people {
                                                        posst.peopleWhoLike1.append(person as! String)
                                                    }
                                                }
                                                
                                                //self.posts.append(posst)
                                                
                                                if let people = post["peopleWhoLike2"] as? [String : AnyObject] {
                                                    for (_,person) in people {
                                                        posst.peopleWhoLike2.append(person as! String)
                                                    }
                                                }
                                                
                                                self.posts.append(posst)
                                                
                                            }
                                        }
                                    }
                                    

                                    self.collectionview.reloadData()
                                                                    }
                            }
                        })
                    }
                }
            }
            
        })
        
        ref.removeAllObservers()
    }

   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        cell.postImage1.loadImageUsingCacheWithUrlString(self.posts[indexPath.row].pathToImage1)
        cell.postImage2.loadImageUsingCacheWithUrlString(self.posts[indexPath.row].pathToImage2)
        cell.authorLabel.text = self.posts[indexPath.row].author
        //cell.userImage.loadImageUsingCacheWithUrlString(self.posts[indexPath.row].userImagePath)
        cell.likeLabel.text = "\(self.posts[indexPath.row].likes1!) Likes"
        cell.like2Label.text = "\(self.posts[indexPath.row].likes2!) Likes"
        cell.postID = self.posts[indexPath.row].postID
        
        for person in self.posts[indexPath.row].peopleWhoLike1 {
                if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likeBtn1.isHidden = true
                cell.unlikeBtn1.isHidden = false
                break
            }
            }
        
        for person in self.posts[indexPath.row].peopleWhoLike2 {
            if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likeBtn2.isHidden = true
                cell.unlikeBtn2.isHidden = false
                break
            }}
        
        return cell
        }
        
        
    
    }
    


