import Fluent
import Vapor

struct RolePermissionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let role_permissions = routes.grouped("api").grouped("role_permissions")
        role_permissions.get(use: index)
        role_permissions.post(use: create)
        role_permissions.group(":rolePermissionID") { role_permission in
            role_permission.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[RolePermission]> {
        return RolePermission.query(on: req.db).with(\.$permission).with(\.$permission_role).all()
    }

    func create(req: Request) throws -> EventLoopFuture<RolePermission> {
        let rolePerm = try req.content.decode(RolePermission.self)
        return rolePerm.save(on: req.db).map { rolePerm }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return RolePermission.find(req.parameters.get("rolePermissionID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
