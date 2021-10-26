import Fluent
import Vapor
//https://localhost:8080/users/3
struct JiraIssueTypeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api").grouped("jira").grouped("issue_types")
//        users.get(use: add)
    }

    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

//    func add(req: Request) throws -> EventLoopFuture<Response> {
//        let add = try req.query.decode(JiraProjectIDC.self)
//        return JiraProject.find(add.id.uuid, on: req.db).flatMap { project -> EventLoopFuture<Response> in
//            guard let a = project else {return req.eventLoop.makeSucceededFuture(req.redirect(to: "web/jira/accounts", type: .temporary))}
//            let uri = URI(string: AppConfig.jiraBaseURL + "issue/createmeta")
//            if let c = req.webToJiraRest(url: uri, token: a, method: .GET, body: nil) {
//                return c.flatMapThrowing { (resp) -> Response in
//                    let obj = try resp.content.decode(JiraProject.ProjectMeta.self)
//                    req.db.transaction { (database) -> EventLoopFuture<Database> in
//                        obj.projects.forEach { (proj) in
//                            proj.saveProj(db: database)
//                        }
//                        return req.eventLoop.makeSucceededFuture(database)
//                    }
//
//                    return Response.init(status: HTTPResponseStatus.init(statusCode: 200, reasonPhrase: "Successffully Added"), version: .http1_1, headers: .init(), body: .empty)
//                }
//            }
//            return req.eventLoop.makeSucceededFuture(req.redirect(to: "web/jira/projects", type: .temporary))
//        }
//    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
