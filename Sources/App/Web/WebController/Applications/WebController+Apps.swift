
import Vapor
import Fluent

protocol WebControllerApplication {
    func apps(_ routes: RoutesBuilder)
}
extension WebControllerApplication {
    func apps(_ routes: RoutesBuilder) {
        routes.group("apps") { b in
            b.get(use: index)
            b.group("add") { newB in
                newB.get(use: addAppForm)
                newB.post(use: insertApp)
            }
            b.get("clone", use: clone)
        }
    }
    func index(req: Request) throws -> EventLoopFuture<View> {
        let session = req.session.data["_UserAuthTokenSession"]
        let user = UserAuthToken()
        user.id = UUID.init(uuidString: session ?? "")
        req.session.authenticate(user)
        if let userObj = req.auth.get(UserAuthToken.self) {
            return ENTApplication.query(on: req.db).with(\.$platform).all().flatMap { (applications) -> (EventLoopFuture<View>) in
                let listApps = applications.map { (app) -> ListAppContent in
                    var lApp = ListAppContent(app: app, have_repo: false)
                    if let app_id = app.id?.uuidString {
                        var isDirectory: ObjCBool = true
                        let path = req.application.directory.publicDirectory + "\(PublicDirectory.repositories.rawValue)/" + app_id + "/.git"
                        let fileExist = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
                        lApp.have_repo = fileExist
                    }
                    return lApp
                }
                
                return req.view.render(LeafName.apps.rawValue, Apps(applications: listApps))
            }
        }
        throw Abort.init(.badRequest)
    }
    func addAppForm(req: Request) throws -> EventLoopFuture<View> {
        return Platform.query(on: req.db).all().flatMap { (platforms) -> EventLoopFuture<View> in
            let dict = ["platforms": platforms]
            return req.view.render(LeafName.add_app.rawValue, dict)
        }
        
    }
    func insertApp(req: Request) throws -> EventLoopFuture<Response> {
        if req.hasSession {
            let uri = URI.init(string: AppConfig.baseURL + "api/ent_applications")
            if let client = req.webToAppRest(url: uri, method: .POST, body: req.body.data) {
                return client.flatMapThrowing { (resp) -> (Response) in
                    if resp.status.code == 200 {
                        return req.redirect(to: "/web/apps", type: .temporary)
                    }else {
                        throw Abort(.unauthorized, reason: resp.status.reasonPhrase)
                    }
                }
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "web", type: .temporary))
    }
    func clone(req: Request) throws -> EventLoopFuture<Response> {
        if req.hasSession {
            let session = req.session.data["_UserAuthTokenSession"]
            let user = UserAuthToken()
            user.id = UUID.init(uuidString: session ?? "")
            req.session.authenticate(user)
            let idc = try req.query.decode(ContentID.self)
            return ENTApplication.find(idc.id.uuid, on: req.db).map { (application) -> (Response) in
                if let app = application {
                    let cs = CloneScript(app_id: app.id!.uuidString, git_url: app.git_url, public_directory: req.application.directory.publicDirectory, repository_directory: PublicDirectory.repositories.rawValue)
                    ScriptManager.shared.addScript(script: cs)
                }
                return req.redirect(to: "", type: .temporary)
            }
        }
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "", type: .temporary))
    }
}
