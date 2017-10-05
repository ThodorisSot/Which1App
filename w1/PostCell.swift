//
//  PostCell.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 29/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var postImage1: UIImageView!
    @IBOutlet var postImage2: UIImageView!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var like2Label: UILabel!
    
    //@IBOutlet weak var userImage: UIImageView!
    
    
   
    @IBOutlet var scrollView1: UIScrollView!
    @IBOutlet var scrollView2: UIScrollView!
    
    @IBOutlet var likeBtn1: UIButton!
    @IBOutlet var unlikeBtn1: UIButton!
    @IBOutlet var likeBtn2: UIButton!
    @IBOutlet var unlikeBtn2: UIButton!
    
    var postID: String!
    
    override func awakeFromNib() {
        //self.scrollView1.minimumZoomScale = 1.0
        //self.scrollView1.maximumZoomScale = 3.0
        //self.scrollView.contentSize=CGSize(width: 350, height: 350)
        //self.scrollView2.minimumZoomScale = 1.0
        //self.scrollView2.maximumZoomScale = 3.0
       
        //self.scrollView1.delegate = self
        //self.scrollView2.delegate = self
    }
    
    //zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        if scrollView == scrollView1 {
            return self.postImage1
        } else {
            return self.postImage2 }
    }
    
    //bounce zoomed image
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView == scrollView1 {
            self.scrollView1.zoomScale = self.scrollView1.minimumZoomScale
        }else if scrollView == scrollView2 {self.scrollView2.zoomScale = self.scrollView2.minimumZoomScale}
    }
    
    @IBAction func like1Pressed(_ sender: Any) {
        self.likeBtn1.isEnabled = false
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike1/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes1 = properties["peopleWhoLike1"] as? [String : AnyObject] {
                                    let count = likes1.count
                                    self.likeLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes1" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtn1.isHidden = true
                                    self.unlikeBtn1.isHidden = false
                                    self.likeBtn1.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
    }
    
    
    
    @IBAction func unlike1Pressed(_ sender: Any) {
        self.unlikeBtn1.isEnabled = false
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike1 = properties["peopleWhoLike1"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike1 {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike1").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes1 = prop["peopleWhoLike1"] as? [String : AnyObject] {
                                                let count = likes1.count
                                                self.likeLabel.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes1" : count])
                                            }else {
                                                self.likeLabel.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes1" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeBtn1.isHidden = false
                            self.unlikeBtn1.isHidden = true
                            self.unlikeBtn1.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    }

    //second image
    
    
    @IBAction func like2Pressed(_ sender: Any) {
        self.likeBtn2.isEnabled = false
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes2: [String : Any] = ["peopleWhoLike2/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes2, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes2 = properties["peopleWhoLike2"] as? [String : AnyObject] {
                                    let count2 = likes2.count
                                    self.like2Label.text = "\(count2) Likes"
                                    
                                    let update = ["likes2" : count2]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtn2.isHidden = true
                                    self.unlikeBtn2.isHidden = false
                                    self.likeBtn2.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
    }
    
    
    @IBAction func unlike2Pressed(_ sender: Any) {
        self.unlikeBtn2.isEnabled = false
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike2 = properties["peopleWhoLike2"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike2 {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike2").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop2 = snap.value as? [String : AnyObject] {
                                            if let likes2 = prop2["peopleWhoLike2"] as? [String : AnyObject] {
                                                let count2 = likes2.count
                                                self.like2Label.text = "\(count2) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes2" : count2])
                                            }else {
                                                self.like2Label.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes2" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeBtn2.isHidden = false
                            self.unlikeBtn2.isHidden = true
                            self.unlikeBtn2.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    

    }
    
    
    @IBAction func seeWho(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
    }
 
    
}
