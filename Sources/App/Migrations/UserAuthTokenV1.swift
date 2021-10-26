//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Vapor
import Fluent

extension UserAuthToken {
    struct UserAuthTokenV1: Fluent.Migration {
        var name: String { "UserAuthTokenV1" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_auth_tokens")
                .id()
                .field("value", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("user_id", .uuid, .required, .references(User.schema, .id))
                .unique(on: "value")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_auth_tokens").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(UserAuthTokenV1())
    }
}
