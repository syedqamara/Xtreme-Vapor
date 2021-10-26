import Fluent
import Vapor
//https://localhost:8080/users/3
struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api").grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
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

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
