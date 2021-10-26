//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor

extension AppResource {
    struct Create: Content {
        var title: String?
        var app_id: String
        var build_mode_id: String
        var cert_password: String?
        var resources: File?
        var certificate: File?
    }
}

// Signup Validation
extension AppResource.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("app_id", as: String.self, is: !.empty)
        validations.add("build_mode_id", as: String.self, is: !.empty)
        validations.add("cert_password", as: String.self, is: !.empty)
        
    }
}




