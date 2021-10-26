//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Vapor
import Fluent


final class Platform: Model, Content {
    static let schema = "platforms"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Children(for: \.$platform)
    var applications: [ENTApplication]

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, title: String, type: String, image_url: String) {
        self.id = id
        self.title = title
        self.type = type
        self.image_url = image_url
    }
}
