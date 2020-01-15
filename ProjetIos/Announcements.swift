//
//  Announcements.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import Foundation
class Announcement {
    
    var id:Int?
    var text:String?
    var user:User?
    
    internal init(id: Int?, text: String?, user: User?) {
        self.id = id
        self.text = text
        self.user = user
    }
    
}
