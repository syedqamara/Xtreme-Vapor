//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension ENTApplication {
    struct ENTApplicationV1: Migration {
        var name: String { "ENTApplicationV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("ent_applications")
                .id()
                .field("name", .string, .required)
                .field("bundle_id", .string, .required)
                .field("image_url", .string, .required)
                .field("git_url", .string, .required)
                .field("project", .string, .required)
                .field("target", .string, .required)
                .field("path_to_project", .string, .required)
                .field("platform_id", .uuid, .required, .references(Platform.schema, .id))
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .unique(on: "bundle_id")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("ent_applications").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(ENTApplicationV1())
    }
}
