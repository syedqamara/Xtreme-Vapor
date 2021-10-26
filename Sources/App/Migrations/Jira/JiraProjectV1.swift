//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor


extension JiraProject {
    struct JiraProjectV1: Migration {
        var name: String { "JiraProjectV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_projects")
                .id()
                .field("jira_id", .string, .required)
                .field("jira_key", .string, .required)
                .field("name", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .unique(on: "jira_id")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_projects").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(JiraProjectV1())
    }
}
