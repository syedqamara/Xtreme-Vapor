//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension Role {
    struct RoleV1: Migration {
        var name: String { "RoleV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("roles")
                .id()
                .field("title", .string, .required)
                .field("description", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("roles").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(RoleV1())
    }
}
