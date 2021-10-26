//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension Permission {
    struct PermissionV1: Migration {
        var name: String { "PermissionV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("permissions")
                .id()
                .field("title", .string, .required)
                .field("description", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("permissions").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(PermissionV1())
    }
}
