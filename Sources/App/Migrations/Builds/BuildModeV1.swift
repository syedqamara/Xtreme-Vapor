//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension BuildMode {
    struct BuildModeV1: Migration {
        var name: String { "BuildModeV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("build_modes")
                .id()
                .field("title", .string, .required)
                .field("identifier", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("build_modes").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(BuildModeV1())
    }
}
