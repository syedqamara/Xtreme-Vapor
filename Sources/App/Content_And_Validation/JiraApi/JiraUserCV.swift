//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor


extension JiraUser {
    struct ApiInfo: Content {
        var accountId: String
        var emailAddress: String
        var displayName: String
        var avatarUrls: [String: String]
        
        var toUser: JiraUser {
            let newUser = JiraUser()
            newUser.id = UUID.init()
            newUser.account_id = accountId
            newUser.email = emailAddress
            newUser.name = displayName
            newUser.image_url = avatarUrls["48x48"]!
            return newUser
        }
    }
}

// Signup Validation
extension JiraUser.ApiInfo: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("emailAddress", as: String.self, is: !.empty)
        validations.add("displayName", as: String.self, is: !.empty)
        
    }
}




