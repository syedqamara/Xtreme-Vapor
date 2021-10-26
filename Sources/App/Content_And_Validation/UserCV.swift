//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//


import Vapor
import Fluent
extension User {
    struct Create: Content {
        var first_name: String
        var last_name: String
        var email: String
        var password: String
        var confirm_password: String
        var role_id: UUID
    }
    struct Login: Content {
        var email: String
        var password: String
    }
    
}

/// Signup Validation
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("first_name", as: String.self, is: !.empty)
        validations.add("last_name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirm_password", as: String.self, is: .count(8...))
    }
}
/// Login Validation
extension User.Login: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}


//Authentication
extension User: ModelAuthenticatable, ModelCredentialsAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
extension UserAuthToken: SessionAuthenticatable {
    var sessionID: UUID {
        self.id!
    }
}
struct UserAuthTokenSessionAuthenticator: SessionAuthenticator {
    typealias User = App.UserAuthToken
    func authenticate(sessionID: User.SessionID, for req: Request) -> EventLoopFuture<Void> {
        UserAuthToken.find(sessionID, on: req.db).map { userObj  in
            if let user = userObj {
                req.auth.login(user)
            }
        }
    }
}
struct UserBearerAuthenticator: BearerAuthenticator {
    
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        let token = UserAuthToken.query(on: request.db).filter(\.$value == bearer.token).first()
        return token.flatMapThrowing { (authToken) throws -> UUID in
            if let user_id = authToken?.$user.id {
                return user_id
            }else {
                throw Abort(.forbidden)
            }
        }.flatMap { (user_id) -> EventLoopFuture<Void> in
            let u = User.query(on: request.db).filter(\._$id == user_id).first()
            let loggedIn = u.flatMapThrowing { (user) throws -> Void in
                guard let u_obj = user else {throw Abort(.notFound)}
                request.auth.login(u_obj)
                return
            }
            return loggedIn
        }
        
    }
}
