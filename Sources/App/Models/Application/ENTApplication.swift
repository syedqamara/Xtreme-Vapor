//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Vapor
import Fluent


final class ENTApplication: Model, Content {
    static let schema = "ent_applications"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "bundle_id")
    var bundle_id: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Field(key: "git_url")
    var git_url: String
    
    @Field(key: "project")
    var project: String
    
    @Field(key: "path_to_project")
    var path_to_project: String
    
    @Field(key: "target")
    var target: String
    
    @Parent(key: "platform_id")
    var platform: Platform

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    var data: [String: Any] = [String: Any]()
    
    init() { }

    
    init(id: UUID? = nil, name: String, bundle_id: String, image_url: String, git_url: String, platformID: Platform.IDValue, project: String, path_to_project: String, target: String) {
        self.id = id
        self.name = name
        self.bundle_id = bundle_id
        self.image_url = image_url
        self.git_url = git_url
        self.$platform.id = platformID
        self.project = project
        self.path_to_project = path_to_project
        self.target = target
    }
    
    var commandd: String {
        return "chmod 777 checkout.sh && ./checkout.sh \(self.git_url) master \(self.bundle_id) enterprise install"
    }
}

