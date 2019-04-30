//
//  UserInfo.swift
//  Quack
//
//  Created by Katya  on 4/20/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import Foundation

class UserInfo{
    var email: String
    
    init(userEmail: String){
    email = userEmail
    }
}

/*
extension UserInfo {
    static func transformUser(dict: [String: Any]) -> UserInfo {
        let user = UserInfo()
        userEmail = dict["email"] as? String
        //user.profileImageUrl = dict["profileImageUrl"] as? String
        //user.username = dict["username"] as? String
        return user
    }
}

*/
