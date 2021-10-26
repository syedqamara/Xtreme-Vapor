//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 20/04/2021.
//

import Vapor


struct CloneScript: Script {
    var app_id: String
    var git_url: String
    var public_directory: String
    var repository_directory: String
    
    var script: String {
        return "\(ScriptPrefix.clone.rawValue) \(public_directory) \(git_url) \(app_id) \(repository_directory)"
    }
    var script_directory_path: String {
        return PublicDirectory.scripts.rawValue
    }
    var script_log_path: String {
        return ScripLogPath.clone.rawValue
    }
}
