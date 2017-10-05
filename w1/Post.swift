//
//  Post.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 29/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var author: String!
    //var userImagePath: String!
    var likes1: Int!
    var likes2: Int!
    var pathToImage1: String!
    var pathToImage2: String!
    var userID: String!
    var postID: String!
    
    var peopleWhoLike1: [String] = [String]()
    var peopleWhoLike2: [String] = [String]()


}
