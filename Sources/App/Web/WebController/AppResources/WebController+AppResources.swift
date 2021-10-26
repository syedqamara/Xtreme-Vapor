import Vapor
import Fluent

protocol WebControllerAppResources {
    func appResource(_ routes: RoutesBuilder)
}
struct AppResourceID: Content {
    var id: String
}

struct AppResources: Content {
    var resources: [AppResource]
}
struct AppResourceDataSource: Content {
    var applications: [ENTApplication]
    var build_modes: [BuildMode]
}
extension WebControllerAppResources {
    func appResource(_ routes: RoutesBuilder) {
        routes.group("app_resources") { resource in
            resource.get(use: all)
            resource.post("add",use: add)
            resource.get("add",use: addForm)
            resource.get("cert_to_keychain",use: cert_to_keychain)
        }
    }
}

extension WebControllerAppResources {
    func all(req: Request) throws -> EventLoopFuture<View> {
        return AppResource.query(on: req.db).with(\.$application, { (buildLoader) in
            buildLoader.with(\.$platform)
        })  .with(\.$build_mode).all().flatMap { (appResources) -> EventLoopFuture<View> in
            return req.view.render(LeafName.app_resources.rawValue,AppResources(resources: appResources))
        }
    }
    func cert_to_keychain(req: Request) throws -> EventLoopFuture<Response> {
        let r = try req.query.decode(AppResourceID.self)
        return AppResource.find(r.id.uuid, on: req.db).map { (appR) -> (Response) in
            if let res = appR {
                ScriptManager.shared.addScript(script: CertficateScript(resource_id: res.id!.uuidString, certPath: res.cert_link, certPassword: res.cert_password, pulicDir: req.application.directory.publicDirectory))
            }
            return req.redirect(to: "", type: .temporary)
        }
    }
    func addForm(req: Request) throws  -> EventLoopFuture<View> {
        let session = req.session.data["_UserAuthTokenSession"]
        let user = UserAuthToken()
        user.id = UUID.init(uuidString: session ?? "")
        req.session.authenticate(user)
        if let userObj = req.auth.get(UserAuthToken.self) {
            return ENTApplication.query(on: req.db).all().flatMap { (applications) -> (EventLoopFuture<View>) in
                return BuildMode.query(on: req.db).all().flatMap { (build_modes) -> EventLoopFuture<View> in
                    let ards = AppResourceDataSource(applications: applications, build_modes: build_modes)
                    return req.view.render(LeafName.add_app_resource.rawValue, ards)
                }
                
            }
        }
        throw Abort.init(.badRequest)
        
    }
    func add(req: Request) throws  -> EventLoopFuture<Response> {
        if req.hasSession {
            let uri = URI.init(string: AppConfig.baseURL + "api/app_resources")
            if let client = req.webToAppRest(url: uri, method: .POST, body: req.body.data) {
                return client.flatMapThrowing { (resp) -> (Response) in
                    if resp.status.code == 200 {
                        return req.redirect(to: "/web/app_resources", type: .temporary)
                    }else {
                        if let b = resp.body {
                            return Response(status: resp.status, version: req.version, headers: req.headers, body: Response.Body.init(buffer: b))
                        }
                        throw Abort(.unauthorized, reason: resp.status.reasonPhrase)
                    }
                }
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "web", type: .temporary))
    }
}
