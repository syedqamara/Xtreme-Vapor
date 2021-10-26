//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension Platform {
    struct PlatformV1: Migration {
        var name: String { "PlatformV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("platforms")
                .id()
                .field("title", .string, .required)
                .field("type", .string, .required)
                .field("image_url", .string, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("platforms").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(PlatformV1())
    }
}
