//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor


extension JiraUser {
    struct JiraUserV1: Migration {
        var name: String { "JiraUserV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_users")
                .id()
                .field("account_id", .string, .required)
                .field("name", .string, .required)
                .field("email", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .unique(on: "account_id")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_users").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(JiraUserV1())
    }
}
