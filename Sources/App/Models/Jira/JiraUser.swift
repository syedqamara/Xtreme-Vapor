//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class JiraUser: Model, Content {
    
    static let schema = "jira_users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "account_id")
    var account_id: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() {
        self.id = UUID.init()
        self.created_at = Date()
        self.updated_at = Date()
    }

    init(id: UUID? = nil, email: String, account_id: String, name: String, image_url: String){
        self.id = id
        self.email = email
        self.account_id = account_id
        self.name = name
        self.image_url = image_url
    }
}


