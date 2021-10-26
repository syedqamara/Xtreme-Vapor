//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Vapor
import Fluent


final class AppResource: Model, Content {
    static let schema = "app_resources"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "cert_password")
    var cert_password: String
    
    @Field(key: "resource_link")
    var resource_link: String
    
    @Field(key: "cert_link")
    var cert_link: String
    
    @Parent(key: "app_id")
    var application: ENTApplication
    
    @Parent(key: "build_mode_id")
    var build_mode: BuildMode
    

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, title: String, appID: ENTApplication.IDValue, buildModeID: BuildMode.IDValue, cert_password: String, resource_link: String, cert_link: String) {
        self.id = id
        self.title = title
        self.$application.id = appID
        self.$build_mode.id = buildModeID
        self.cert_password = cert_password
        self.resource_link = resource_link
        self.cert_link = cert_link
    }
}
