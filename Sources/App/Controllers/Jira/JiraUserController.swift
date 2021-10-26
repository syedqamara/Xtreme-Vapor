import Fluent
import Vapor
//https://localhost:8080/users/3
struct JiraUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api").grouped("jira").grouped("users")
        users.post(use: create)
    }
    func create(req: Request) throws -> EventLoopFuture<JiraUser> {
        let create = try req.content.decode(JiraUser.self)
        return create.save(on: req.db).map({create})
    }
}
