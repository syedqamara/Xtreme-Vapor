import Fluent
import Vapor

struct PermissionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let permissions = routes.grouped("api").grouped("permissions")
        permissions.get(use: index)
        permissions.post(use: create)
        permissions.group(":permissionID") { permission in
            permission.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Permission]> {
        return Permission.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Permission> {
        let perm = try req.content.decode(Permission.self)
        return perm.save(on: req.db).map { perm }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Permission.find(req.parameters.get("permissionID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
