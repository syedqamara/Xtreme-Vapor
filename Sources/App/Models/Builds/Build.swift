//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Fluent
import Vapor



final class Build: Model, Content {
    static let schema = "builds"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "git_branch")
    var git_branch: String
    
    @Field(key: "build_link")
    var build_link: String
    
    @Field(key: "script_log_file_path")
    var script_log_file_path: String
    
    @Field(key: "build_status")
    var build_status: String
    
    @Field(key: "release_notes")
    var release_notes: String
    // Build Mode -> (Ad-hoc, Enterprise, Development, Production)
    @Parent(key: "build_mode_id")
    var build_mode: BuildMode
    
    @Parent(key: "app_id")
    var application: ENTApplication
    // Build Node -> (QA-Node, DEV-Node, RC-Node, PROD-Node)
    @Parent(key: "build_node_id")
    var build_node: BuildNode

    @Timestamp(key: "build_expire_date", on: TimestampTrigger.create)
    var build_expire_date: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, git_branch: String, build_link: String, script_log_file_path: String, buildModeID: BuildMode.IDValue, buildNodeID: BuildNode.IDValue, appID: ENTApplication.IDValue, build_expire_date: Date?, release_notes: String, build_status: String) {
        self.id = id
        self.git_branch = git_branch
        self.build_link = build_link
        self.script_log_file_path = script_log_file_path
        self.$build_mode.id = buildModeID
        self.$build_node.id = buildNodeID
        self.$application.id = appID
        self.build_expire_date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 31536000.0)
        self.release_notes = release_notes
        self.build_status = build_status
    }
}
