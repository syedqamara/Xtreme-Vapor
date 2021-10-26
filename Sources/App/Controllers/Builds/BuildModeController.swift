import Fluent
import Vapor

struct BuildModeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bModes = routes.grouped("api").grouped("build_modes")
        bModes.get(use: index)
        bModes.post(use: create)
        bModes.group(":buildModeID") { bMode in
            bMode.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[BuildMode]> {
        return BuildMode.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BuildMode> {
        let bMode = try req.content.decode(BuildMode.self)
        return bMode.save(on: req.db).map { bMode }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BuildMode.find(req.parameters.get("buildModeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
