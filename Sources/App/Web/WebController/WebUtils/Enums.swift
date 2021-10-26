//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 21/04/2021.
//

import Vapor

enum LeafName: String {
    case login = "admin_login"
    case apps = "apps"
    case builds = "builds"
    case app_resources = "app_resources"
    case add_app = "add_app"
    case add_build = "add_build"
    case add_app_resource = "add_app_resource"
    enum Jira: String {
        case accounts = "Jira/jira_accounts"
        case users = "Jira/jira_users"
        case projects = "Jira/jira_projects"
        case add_account = "Jira/add_jira_account"
        case add_user = "Jira/add_jira_user"
        case add_project = "Jira/add_jira_project"
    }
}
