//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Vapor
import Fluent


final class Permission: Model, Content {
    static let schema = "permissions"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Children(for: \.$permission)
    var rolePermissions: [RolePermission]

    init() { }

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init(id: UUID? = nil, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
