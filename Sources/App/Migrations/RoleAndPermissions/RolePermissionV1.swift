//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension RolePermission {
    struct RolePermissionV1: Migration {
        var name: String { "RolePermissionV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("role_permissions")
                .id()
                .field("role_id", .uuid, .required, .references(Role.schema, .id))
                .field("permission_id", .uuid, .required, .references(Permission.schema, .id))
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("role_permissions").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(RolePermissionV1())
    }
}
