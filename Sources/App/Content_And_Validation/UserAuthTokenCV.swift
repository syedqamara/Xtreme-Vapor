//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor
import JWT

extension User {
    func generateToken() throws -> UserAuthToken {
        try .init(
            value: [UInt8].random(count: 52).base64,
            userID: self.requireID()
        )
    }
}

import Vapor
import Fluent

extension UserAuthToken: ModelTokenAuthenticatable {
    static let valueKey = \UserAuthToken.$value
    static let userKey = \UserAuthToken.$user

    var isValid: Bool {
        true
    }
}
