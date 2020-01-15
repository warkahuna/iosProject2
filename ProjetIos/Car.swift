//
//  Car.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import Foundation

class Car {
    
    var maker:String?
    var model:String?
    var user:User?
    internal init(maker: String?, model: String?, user: User?) {
        self.maker = maker
        self.model = model
        self.user = user
    }
}
