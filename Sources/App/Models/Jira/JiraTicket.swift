//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class JiraTicket: Model, Content {
    
    static let schema = "jira_tickets"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "jira_id")
    var jira_id: String
    
    @Field(key: "jira_key")
    var jira_key: String
    
    @Field(key: "summary")
    var summary: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "duedate")
    var duedate: String
    
    @Field(key: "labels")
    var labels: String
    
    @Parent(key: "jira_issue_type_id")
    var jiraIssueType: JiraIssueType
    
    @Parent(key: "jira_assignee")
    var jiraAssignee: JiraUser
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, jira_id: String, jira_key: String, summary: String, description: String, duedate: String, labels: String, jiraIssueTypeID: JiraIssueType.IDValue, jiraAssignee: JiraUser.IDValue){
        self.id = id
        self.jira_id = jira_id
        self.jira_key = jira_key
        self.summary = summary
        self.description = description
        self.duedate = duedate
        self.labels = labels
        self.$jiraIssueType.id = jiraIssueTypeID
        self.$jiraAssignee.id = jiraAssignee
    }
}


