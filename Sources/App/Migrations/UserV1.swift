//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension User {
    struct UserV1: Migration {
        var name: String { "UserV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users")
                .id()
                .field("first_name", .string, .required)
                .field("last_name", .string, .required)
                .field("email", .string, .required)
                .field("password", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("role_id", .uuid, .required, .references(Role.schema, .id))
                .unique(on: "email")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(UserV1())
    }
}
