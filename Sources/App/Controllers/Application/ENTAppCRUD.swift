//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 17/04/2021.
//

import Vapor
import Fluent

struct ENTAppCRUD: Content {
    var name: String
    var bundle_id: String
    var git_url: String
    var platform: String
    var project: String
    var path_to_project: String
    var target: String
    var image: File
    
}
