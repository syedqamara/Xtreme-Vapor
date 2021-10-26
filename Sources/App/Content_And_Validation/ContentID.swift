//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 20/04/2021.
//

import Vapor
import Fluent

struct ContentID: Content {
    var id: String
}
struct ContentOptionalID: Content {
    var id: String?
}
