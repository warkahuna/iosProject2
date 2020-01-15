//
//  Garage.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import Foundation
class Garage {
    
    var cars:[Car]?
    var carParts:[CarParts]
    var user:User?
    
    internal init(cars: [Car]?, carParts: [CarParts], user: User?) {
        self.cars = cars
        self.carParts = carParts
        self.user = user
    }
}
