//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "first_name")
    var first_name: String
    
    @Field(key: "last_name")
    var last_name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String

    @Parent(key: "role_id")
    var role: Role
    
    @Children(for: \.$user)
    var tokens: [UserAuthToken]
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, first_name: String, last_name: String, email: String, password: String, roleID: Role.IDValue){
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.password = password
        self.$role.id = roleID
    }
}


