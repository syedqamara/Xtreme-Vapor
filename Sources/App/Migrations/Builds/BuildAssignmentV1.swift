//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

extension BuildAssignment {
    struct BuildAssignmentV1: Migration {
        var name: String { "BuildAssignmentV1" }
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("builds_assignments")
                .id()
                .field("user_id", .uuid, .required, .references(User.schema, .id))
                .field("build_id", .uuid, .required, .references(Build.schema, .id))
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("builds_assignments").delete()
        }
    }
    class func migrations(_ app: Application) {
        app.migrations.add(BuildAssignmentV1())
    }
}
