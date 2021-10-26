import Fluent
import Vapor
//https://localhost:8080/users/3
struct JiraAccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api").grouped("jira").grouped("accounts")
        users.post(use: create)
    }

    func create(req: Request) throws -> EventLoopFuture<JiraAccount> {
        let create = try req.content.decode(JiraAccount.self)
        return create.save(on: req.db).map({create})
    }
}


extension JiraAccount {
    var basicAuth: String {
        let loginString = String(format: "%@:%@", email, api_token)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
}
