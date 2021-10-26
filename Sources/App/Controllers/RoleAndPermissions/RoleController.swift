import Fluent
import Vapor

struct RoleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let roles = routes.grouped("api").grouped("roles")
        roles.get(use: index)
        roles.post(use: create)
        roles.group(":roleID") { role in
            role.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Role]> {
        try req.auth.require(User.self)
        let u = req.auth.get(User.self)
        if let user = u {
            print("Currently Logged In User Email \(user.email)")
            return user.$role.get(on: req.db).flatMapThrowing({ (role) -> Role in
                if role.title != "DEV" {
                    throw Abort(.badRequest, reason: "\(role.description) do not have access to this feature")
                }
                return role
            }).flatMap({ (_) -> EventLoopFuture<[Role]> in
                return Role.query(on: req.db).all()
            })
        }
        throw Abort(.badRequest, reason: "No User Found")
    }

    func create(req: Request) throws -> EventLoopFuture<Role> {
        let role = try req.content.decode(Role.self)
        return role.save(on: req.db).map { role }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Role.find(req.parameters.get("roleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
