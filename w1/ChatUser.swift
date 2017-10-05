//
//  ChatUser.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 11/04/2017.
//  Copyright © 2017 Theodore N. Sotiriou. All rights reserved.
//


import UIKit

class ChatUser: NSObject {
    var userID: String?
    var fullName: String?
    var imagePath: String?
    
    init(dictionary: [String: AnyObject]) {
        self.userID = dictionary["userID"] as? String
        self.fullName = dictionary["full name"] as? String
        //self.email = dictionary["email"] as? String
        self.imagePath = dictionary["urlToImage"] as? String
    }
    
    
}
