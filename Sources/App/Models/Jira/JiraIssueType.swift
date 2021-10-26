//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

final class JiraIssueType: Model, Content {
    
    static let schema = "jira_issue_types"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "jira_id")
    var jira_id: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Parent(key: "jira_project_id")
    var jiraIssueTypeProj: JiraProject
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, jira_id: String, name: String, image_url: String, jiraProjID: JiraProject.IDValue){
        self.id = id
        self.jira_id = jira_id
        self.name = name
        self.image_url = image_url
        self.$jiraIssueTypeProj.id = jiraProjID
    }
}


