//
//  SignupViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 22/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
   
   
    @IBOutlet weak var newName: UITextField!
    
    
   
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storage = FIRStorage.storage().reference(forURL: "gs://neww1-ecc34.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    

    
    @IBAction func changePressed(_ sender: Any) {
    
    guard newName.text != "" else {return}
    guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
    self.ref.child("users").child(uid).child("full name").setValue(newName.text)
    }
    
}
    
    

