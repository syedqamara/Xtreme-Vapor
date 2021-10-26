
import Vapor
import Fluent



protocol WebControllerJira {
    func jira(_ routes: RoutesBuilder)
}

extension WebControllerJira {
    func jira(_ routes: RoutesBuilder) {
        routes.group("jira") { signin in
            signin.get(use: jira_accounts)
            signin.group("accounts") { account in
                account.get(use: jira_accounts_add_form)
                account.post(use: jira_accounts_add)
            }
            signin.group("users") { users in
                users.get(use: jira_users)
                users.get("add", use: jira_users_add_form)
                users.post("add", use: jira_users_add)
            }
            signin.group("issues_types") { issues_types in
                issues_types.get(use: jira_accounts_add_form)
            }
            signin.group("projects") { projects in
                projects.get(use: jira_projects)
                projects.get("add", use: jira_add_projects)
            }
            signin.group("tickets") { tickets in
                tickets.get(use: jira_accounts_add_form)
            }
        }
    }
    
}

extension WebControllerJira {
    func jira_projects(req: Request) throws -> EventLoopFuture<View> {
        return JiraProject.query(on: req.db).all().flatMap { (projs) -> EventLoopFuture<View> in
            return req.view.render(LeafName.Jira.projects.rawValue, JiraProjectC(projects: projs))
        }
    }
    func jira_add_projects(req: Request) throws -> EventLoopFuture<Response> {
        let id = try req.query.decode(JiraAddUserC.self)
        let uri = URI(string: AppConfig.baseURL + "api/jira/projects?jira_account=\(id.jira_account)")
        if let c = req.webToAppRest(url: uri, method: .GET, body: nil) {
            return c.map { (resp) -> Response in
                if resp.status.code == 200 {
                    return req.redirect(to: "jira", type: .temporary)
                }
                return req.redirect(to: "projects", type: .temporary)
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "projects", type: .temporary))
    }
}

extension WebControllerJira {
    func jira_users(req: Request) throws -> EventLoopFuture<View> {
        return JiraUser.query(on: req.db).all().flatMap { (users) -> EventLoopFuture<View> in
            return req.view.render(LeafName.Jira.users.rawValue, JiraUserC(users: users))
        }
    }
    func jira_users_add_form(req: Request) throws -> EventLoopFuture<View> {
        return JiraAccount.query(on: req.db).all().flatMap { (accs) -> EventLoopFuture<View> in
            return req.view.render(LeafName.Jira.add_user.rawValue, JiraAccountC(accounts: accs))
        }
    }
    func jira_users_add(req: Request) throws -> EventLoopFuture<Response> {
        let add = try req.content.decode(JiraAddUserC.self)
        return JiraAccount.find(add.jira_account.uuid, on: req.db).flatMap { (jiraAcc) -> EventLoopFuture<Response> in
            if let acc = jiraAcc {
                let uri = URI(string: AppConfig.jiraBaseURL + "user/search?query=\(acc.email)")
                if let c = req.webToJiraRest(url: uri, token: acc.basicAuth, method: .GET, body: nil) {
                    return c.flatMapThrowing { (userResp) -> JiraUser.ApiInfo in
                        return (try userResp.content.decode([JiraUser.ApiInfo].self)).first!
                    }.flatMap { (us) -> EventLoopFuture<Response> in
                        let uri = URI(string: AppConfig.baseURL + "api/jira/users")
                        
                        if let client = req.webToApi(url: uri, method: .POST, body: us.toUser) {
                            return client.map { (resp) -> Response in
                                if resp.status.code == 200 {
                                    return req.redirect(to: "", type: .temporary)
                                }
                                return req.redirect(to: "add", type: .temporary)
                            }
                        }
                        return req.eventLoop.makeSucceededFuture(req.redirect(to: "users/add", type: .temporary))
                    }
                }
            }
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "users/add", type: .temporary))
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "accounts", type: .temporary))
    }
}


extension WebControllerJira {
    func jira_accounts(req: Request) throws -> EventLoopFuture<View> {
        return JiraAccount.query(on: req.db).all().flatMap { (accs) -> EventLoopFuture<View> in
            return req.view.render(LeafName.Jira.accounts.rawValue, JiraAccountC(accounts: accs))
        }
    }
    func jira_accounts_add_form(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render(LeafName.Jira.add_account.rawValue)
    }
    func jira_accounts_add(req: Request) throws -> EventLoopFuture<Response> {
        let uri = URI(string: AppConfig.baseURL + "api/jira/accounts")
        if let c = req.webToAppRest(url: uri, method: .POST, body: req.body.data) {
            return c.map { (resp) -> Response in
                if resp.status.code == 200 {
                    return req.redirect(to: "jira", type: .temporary)
                }
                return req.redirect(to: "accounts", type: .temporary)
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "accounts", type: .temporary))
    }
}
