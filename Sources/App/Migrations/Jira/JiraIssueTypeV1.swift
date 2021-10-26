//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor


extension JiraIssueType {
    struct JiraIssueTypeV1: Migration {
        var name: String { "JiraIssueTypeV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_issue_types")
                .id()
                .field("jira_id", .string, .required)
                .field("name", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("jira_project_id", .uuid, .required, .references(JiraProject.schema, .id))
                .unique(on: "jira_id")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_issue_types").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(JiraIssueTypeV1())
    }
}
