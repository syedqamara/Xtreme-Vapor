//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 10/04/2021.
//

import Fluent
import Vapor

final class BuildMode: Model, Content {
    static let schema = "build_modes"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "identifier")
    var identifier: String
    
    @Field(key: "image_url")
    var image_url: String

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }

    init(id: UUID? = nil, title: String, identifier: String, image_url: String) {
        self.id = id
        self.title = title
        self.identifier = identifier
        self.image_url = image_url
    }
}
