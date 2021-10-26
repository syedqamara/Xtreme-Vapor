import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("api").grouped("auth")
        auth.group("signin") { signin in
            signin.post(use: signIn)
        }
        auth.group("signup") { signup in
            signup.post(use: signUp)
        }
    }
    func signIn(req: Request) throws -> EventLoopFuture<UserAuthToken.TokenResponse> {
        let login = try req.content.decode(User.Login.self)
        let tokenFuture = User.query(on: req.db).filter(\.$email == login.email).first().flatMapThrowing { (userOptional) throws -> UserAuthToken in
            guard let user = userOptional else {throw Abort(.notFound, reason: "No user found with email \(login.email)")}
            let verify = try user.verify(password: login.password)
            if verify {
//                user.email = login.email
//                user.password = login.password
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
        return t.map { (authToken) -> (UserAuthToken.TokenResponse) in
            let tr = UserAuthToken.TokenResponse.init(user: authToken.user, token: authToken.value)
            return tr
        }
    }

    func signUp(req: Request) throws -> EventLoopFuture<User> {
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirm_password else {
                throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = Role.query(on: req.db).filter(\.$id == create.role_id).first().flatMapThrowing({ (role) -> User in
            guard let r = role else {throw Abort.init(.notFound)}
            let user = try User(first_name: create.first_name, last_name: create.last_name, email: create.email, password: Bcrypt.hash(create.password), roleID: r.requireID())
            _ = user.$role.get(on: req.db)
            return user
        })
        let finalResult = user.flatMap { (user) -> EventLoopFuture<User> in
            return user.save(on: req.db).map({user})
        }
        return finalResult
    }
}
