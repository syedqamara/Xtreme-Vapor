//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 19/04/2021.
//

import Vapor
import Fluent



extension Build {
    struct Create: Content {
        var git_branch: String
        var build_mode_id: String
        var app_id: String
        var build_node_id: String
        var release_notes: String
        
    }
    struct Update: Content {
        var id: String
        var git_branch: String?
        var build_link: String?
        var script_log_file_path: String?
        var build_status: String?
        var build_mode_id: String?
        var app_platform_id: String?
        var build_node_id: String?
    }
    struct Manifest: Content {
        var id: String
        var url: String
        var version: String
        var title: String
        var bundle: String
    }
}

// Signup Validation
extension Build.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("git_branch", as: String.self, is: !.empty)
        validations.add("build_mode_id", as: String.self, is: !.empty)
        validations.add("app_id", as: String.self, is: !.empty)
        validations.add("build_node_id", as: String.self, is: !.empty)
    }
}
