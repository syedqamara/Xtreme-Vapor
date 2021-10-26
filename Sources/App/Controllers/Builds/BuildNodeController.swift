import Fluent
import Vapor

struct BuildNodeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bNodes = routes.grouped("api").grouped("build_nodes")
        bNodes.get(use: index)
        bNodes.post(use: create)
        bNodes.group(":buildNodeID") { bNode in
            bNode.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[BuildNode]> {
        return BuildNode.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BuildNode> {
        let bNode = try req.content.decode(BuildNode.self)
        return bNode.save(on: req.db).map { bNode }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BuildNode.find(req.parameters.get("buildNodeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
