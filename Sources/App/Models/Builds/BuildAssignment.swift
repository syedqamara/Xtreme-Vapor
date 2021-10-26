//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Fluent
import Vapor

final class BuildAssignment: Model, Content {
    static let schema = "builds_assignments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "build_id")
    var build: Build
    
    @Parent(key: "user_id")
    var buildUser: User

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, buildID: Build.IDValue, buildUserID: User.IDValue) {
        self.id = id
        self.$build.id = buildID
        self.$buildUser.id = buildUserID
    }
}
