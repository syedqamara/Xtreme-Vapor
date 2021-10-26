//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Vapor
import Fluent

final class RolePermission: Model, Content {
    static let schema = "role_permissions"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "role_id")
    var permission_role: Role
    
    @Parent(key: "permission_id")
    var permission: Permission

    init() { }

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init(id: UUID? = nil, roleID: Role.IDValue, permissionID: Permission.IDValue) {
        self.id = id
        self.$permission_role.id = roleID
        self.$permission.id = permissionID
    }
}

