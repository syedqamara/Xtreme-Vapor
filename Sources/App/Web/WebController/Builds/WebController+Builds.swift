
import Vapor
import Fluent

protocol WebControllerBuilds {
    func builds(_ routes: RoutesBuilder)
}

struct BuildDataSource: Content {
    var applications: [ENTApplication]
    var build_modes: [BuildMode]
    var build_nodes: [BuildNode]
}

extension WebControllerBuilds {
    func builds(_ routes: RoutesBuilder) {
        routes.group("builds") { newB in
            newB.get(use: all_builds)
            newB.get("add", use: build)
            newB.post("deploy", use: create_build)
        }
    }
    func all_builds(req: Request) throws -> EventLoopFuture<View> {
        let builds = Build.query(on: req.db).with(\.$application, { (buildLoader) in
            buildLoader.with(\.$platform)
        }).all()
        return builds.flatMap { (_builds) -> EventLoopFuture<View> in
            return req.view.render(LeafName.builds.rawValue, ["builds": _builds])
        }
    }
    func create_build(req: Request) throws -> EventLoopFuture<Response> {
        if req.hasSession {
            let session = req.session.data["_UserAuthTokenSession"]
            let user = UserAuthToken()
            user.id = UUID.init(uuidString: session ?? "")
            req.session.authenticate(user)
            guard let token = req.auth.get(UserAuthToken.self) else {
                throw Abort(.unauthorized, reason: "No Authentication token found.")
            }
            var header = req.headers
            header.add(name: "Authorization", value: "Bearer "+token.value)
            let uri = URI.init(string: AppConfig.baseURL + "api/builds")
            let request = ClientRequest(method: .POST, url: uri, headers: header, body: req.body.data)
            
            let reqHandler = { ((requestObj: ClientRequest) throws -> ()).self
                print("Request Handler is Invoking")
            }
            let client = req.client.post(request.url, headers: request.headers) { (requestBefore) in
                requestBefore.body = req.body.data
                print("Befoore Request is initiating")
            }
            
            return client.flatMapThrowing { (resp) -> (Response) in
                if resp.status.code == 200 {
                    return req.redirect(to: "/web/builds", type: .temporary)
                }else {
                    throw Abort(.unauthorized, reason: resp.status.reasonPhrase)
                }
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "web", type: .temporary))
    }
    func build(req: Request) throws -> EventLoopFuture<View> {
        let session = req.session.data["_UserAuthTokenSession"]
        let user = UserAuthToken()
        user.id = UUID.init(uuidString: session ?? "")
        req.session.authenticate(user)
        if let userObj = req.auth.get(UserAuthToken.self) {
            return ENTApplication.query(on: req.db).all().flatMap { (applications) -> (EventLoopFuture<View>) in
                return BuildMode.query(on: req.db).all().flatMap { (build_modes) -> EventLoopFuture<View> in
                    return BuildNode.query(on: req.db).all().flatMap { (build_nodes) -> EventLoopFuture<View> in
                        let bds = BuildDataSource(applications: applications, build_modes: build_modes, build_nodes: build_nodes)
                        return req.view.render(LeafName.add_build.rawValue, bds)
                    }
                }
                
            }
        }
        throw Abort.init(.badRequest)
    }
}
