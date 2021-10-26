//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class JiraProject: Model, Content {
    
    static let schema = "jira_projects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "jira_id")
    var jira_id: String
    
    @Field(key: "jira_key")
    var jira_key: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Children(for: \.$jiraIssueTypeProj)
    var issueTypes: [JiraIssueType]
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, jira_id: String, jira_key: String, name: String, image_url: String){
        self.id = id
        self.jira_id = jira_id
        self.jira_key = jira_key
        self.name = name
        self.image_url = image_url
    }
}


