//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension JiraAccount {
    struct JiraAccountV1: Migration {
        var name: String { "JiraAccountV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_accounts")
                .id()
                .field("email", .string, .required)
                .field("api_token", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .unique(on: "email")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_accounts").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(JiraAccountV1())
    }
}
