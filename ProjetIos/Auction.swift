//
//  Auction.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import Foundation

class Auction {
    internal init(name: String?, ref: String?, price: Float?, user: User) {
        self.name = name
        self.ref = ref
        self.price = price
        self.user = user
    }
    
    
    var name:String?
    var ref:String?
    var price:Float?
    var user:User
    
}
