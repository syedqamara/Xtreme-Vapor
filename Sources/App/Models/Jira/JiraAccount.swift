//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class JiraAccount: Model, Content {
    
    static let schema = "jira_accounts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "api_token")
    var api_token: String
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, email: String, api_token: String){
        self.id = id
        self.email = email
        self.api_token = api_token
    }
}


