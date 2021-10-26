//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor


extension JiraTicket {
    struct JiraTicketV1: Migration {
        var name: String { "JiraTicketV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_tickets")
                .id()
                .field("jira_id", .string, .required)
                .field("jira_key", .string, .required)
                .field("summary", .string, .required)
                .field("description", .string, .required)
                .field("duedate", .string, .required)
                .field("labels", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("jira_issue_type_id", .uuid, .required, .references(JiraIssueType.schema, .id))
                .field("jira_assignee", .uuid, .required, .references(JiraUser.schema, .id))
                .unique(on: "jira_id")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("jira_tickets").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(JiraTicketV1())
    }
}
