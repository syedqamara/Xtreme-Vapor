//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 20/04/2021.
//

import Vapor
import Fluent

struct ListAppContent: Content {
    var app: ENTApplication
    var have_repo: Bool
}

struct Apps: Content {
    var applications: [ListAppContent]
}
