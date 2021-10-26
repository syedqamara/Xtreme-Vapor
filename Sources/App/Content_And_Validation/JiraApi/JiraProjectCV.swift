//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor
import Fluent


extension JiraProject {
    struct ProjectMeta: Content {
        var projects: [Project]
    }
    struct Project: Content {
        var id: String
        var key: String
        var name: String
        var avatarUrls: [String: String]
        var issuetypes: [Issues]
        func saveProj(db: Database) -> Void {
            let newProj = JiraProject()
            newProj.id = UUID.init()
            newProj.jira_id = id
            newProj.jira_key = key
            newProj.name = name
            newProj.image_url = avatarUrls["48x48"]!
            _ = newProj.save(on: db).map({ (_) -> (Void) in
//                _ = newProj.$issueTypes.create(issues, on: db)
            })
            return
        }
    }
    struct Issues: Content {
        var id: String
        var name: String
        var iconUrl: String
        
        var toIssueType: JiraIssueType {
            let newIssueType = JiraIssueType()
            newIssueType.id = UUID.init()
            newIssueType.jira_id = id
            newIssueType.name = name
            newIssueType.image_url = iconUrl
            return newIssueType
        }
    }
}





