import Fluent
import Vapor

struct PlatformController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bs = routes.grouped("api").grouped("platforms")
        bs.get(use: index)
        bs.post(use: create)
        bs.group(":platformID") { b in
            b.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Platform]> {
        return Platform.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Platform> {
        let b = try req.content.decode(Platform.self)
        return b.save(on: req.db).map { b }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Platform.find(req.parameters.get("platformID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
