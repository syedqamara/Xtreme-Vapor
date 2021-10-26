//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension Build {
    struct BuildV1: Migration {
        var name: String { "BuildV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("builds")
                .id()
                .field("git_branch", .string, .required)
                .field("build_link", .string, .required)
                .field("release_notes", .string, .required)
                .field("build_status", .string, .required)
                .field("script_log_file_path", .string, .required)
                .field("build_mode_id", .uuid, .required, .references(BuildMode.schema, .id))
                .field("app_id", .uuid, .required, .references(ENTApplication.schema, .id))
                .field("build_node_id", .uuid, .required, .references(BuildNode.schema, .id))
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("build_expire_date", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("builds").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(BuildV1())
    }
}
