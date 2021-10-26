import Fluent
import Vapor

struct BuildAssignmentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bs = routes.grouped("api").grouped("build_assignments")
        bs.get(use: index)
        bs.post(use: create)
        bs.group(":buildAssignmentID") { b in
            b.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[BuildAssignment]> {
        return BuildAssignment.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BuildAssignment> {
        let b = try req.content.decode(BuildAssignment.self)
        return b.save(on: req.db).map { b }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BuildAssignment.find(req.parameters.get("buildAssignmentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
