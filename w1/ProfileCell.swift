//
//  ProfileCell.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 09/01/2017.
//  Copyright © 2017 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class ProfileCell: UICollectionViewCell {
    
    
    @IBOutlet var Image1: UIImageView!
    @IBOutlet var Image2: UIImageView!
    
    var postID: String!
    
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var like2Label: UILabel!
    
    @IBAction func deletePressed(_ sender: Any) {
        //guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
     
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in

            if let post = snapshot.value as? [String : AnyObject] {
                ref.child("posts").child(self.postID).removeValue()
        
            }})
        ref.removeAllObservers()
    }
    
    
    
    
}
