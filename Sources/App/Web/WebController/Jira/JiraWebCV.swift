//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 25/04/2021.
//

import Vapor
import Fluent
///Jira Accounts Web Response Model
struct JiraAccountC: Content {
    var accounts: [JiraAccount]
}
///Jira Users Web Response Model
struct JiraUserC: Content {
    var users: [JiraUser]
}
///Jira Add User Web Response Model
struct JiraAddUserC: Content {
    var jira_account: String
}
///Jira Sync Project Request Model
struct JiraProjectIDC: Content {
    var id: String
}
///Jira Sync Issue Type Request Model
struct JiraIssueTypeIDC: Content {
    var id: String
}


///Jira Projects Web Response Model
struct JiraProjectC: Content {
    var projects: [JiraProject]
}
