//
//  Model.swift
//  MobdevDogs
//
//  Created by Marvel Alvarez Rojas on 09/10/2018.
//  Copyright © 2018 Marvel Alvarez Rojas. All rights reserved.
//

import Foundation

struct Doglist : Decodable {
    var status: String
    var message: [String]
}
