//
//  User.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import Foundation

class User {
    
    var id:Int?
    var username:String?
    var password:String?
    internal init(id: Int?, username: String?, password: String?) {
        self.id = id
        self.username = username
        self.password = password
    }
    
}
