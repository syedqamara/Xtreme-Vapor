
import Vapor
import Fluent

protocol WebControllerAuthentication {
    func auth(_ routes: RoutesBuilder)
}

extension WebControllerAuthentication {
    func auth(_ routes: RoutesBuilder) {
        routes.get(use: admin_login)
        routes.get("logout", use: admin_logout)
        routes.group("auth") { signin in
            let protectedSigning = signin.grouped(User.credentialsAuthenticator())
            protectedSigning.post(use: admin_authenticate)
            signin.get("jira",use: jira_authentication)
        }
    }
    func jira_authentication(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render(LeafName.Jira.accounts.rawValue)
    }
    func admin_logout(req: Request) throws -> EventLoopFuture<Response> {
        req.session.destroy()
        return req.eventLoop.makeSucceededFuture(req.redirect(to: ""))
    }
    func admin_login(req: Request) throws -> EventLoopFuture<View> {
        if req.hasSession, let session = req.session.data["_UserAuthTokenSession"] {
            let user = UserAuthToken()
            user.id = UUID.init(uuidString: session)
            req.session.authenticate(user)
            if let userObj = req.auth.get(UserAuthToken.self) {
                throw Abort.redirect(to: "apps", type: .temporary)
            }
        }
        return req.view.render(LeafName.login.rawValue)
    }
    func admin_authenticate(req: Request) throws -> EventLoopFuture<Response> {
        let login = try req.content.decode(User.Login.self)
        let tokenFuture = User.query(on: req.db).filter(\.$email == login.email).first().flatMapThrowing { (userOptional) throws -> UserAuthToken in
            guard let user = userOptional else {throw Abort(.notFound, reason: "No user found with email \(login.email)")}
            let verify = try user.verify(password: login.password)
            if verify {
                req.auth.login(user)
                let token = try user.generateToken()
                token.$user.value = user
                return token
            }
            throw Abort(.unauthorized, reason: "Authentication failed! Due to password validation")
        }
        let t = tokenFuture.flatMap { (token) -> EventLoopFuture<UserAuthToken> in
            return token.save(on: req.db).map { token }
        }
        return t.map { (authToken) -> (Response) in
            let tr = UserAuthToken.TokenResponse.init(user: authToken.user, token: authToken.value)
            req.session.authenticate(authToken)
            req.auth.login(authToken)
            return req.redirect(to: "apps", type: .temporary)
        }
    }
    
}
