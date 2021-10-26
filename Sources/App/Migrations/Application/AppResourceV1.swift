//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension AppResource {
    struct AppResourceV1: Migration {
        var name: String { "AppResourceV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("app_resources")
                .id()
                .field("title", .string, .required)
                .field("cert_password", .string, .required)
                .field("resource_link", .string, .required)
                .field("cert_link", .string, .required)
                .field("app_id", .uuid, .required, .references(ENTApplication.schema, .id, onDelete: .cascade))
                .field("build_mode_id", .uuid, .required, .references(BuildMode.schema, .id, onDelete: .cascade))
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("app_resources").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(AppResourceV1())
    }
}
