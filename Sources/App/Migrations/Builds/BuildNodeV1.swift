//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension BuildNode {
    struct BuildNodeV1: Migration {
        var name: String { "BuildNodeV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("build_nodes")
                .id()
                .field("title", .string, .required)
                .field("identifier", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("build_nodes").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(BuildNodeV1())
    }
}
