//
//  File.swift
//
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor

extension Role {
    struct Create: Content {
        var title: String
        var description: String
    }
}

// Signup Validation
extension Role.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("description", as: String.self, is: !.empty)
    }
}
