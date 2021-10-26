import Fluent
import Vapor

fileprivate let controller_id = "ent_applications"

fileprivate struct ENTAppID: Content {
    var id: String
}

struct AppResourceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rs = routes.grouped("api").grouped("app_resources")
        
        rs.post(use: create)
        rs.post("update",use: update)
        rs.group(":appResourceID") { r in
            r.delete(use: delete)
            
        }
    }
    func create(req: Request) throws -> EventLoopFuture<Response> {
        do {
            var appResource = try req.content.decode(AppResource.Create.self)
            let zip_path = "ios/"+UUID.init().uuidString + ".zip"
            let cert_path = "ios/"+UUID.init().uuidString + ".p12"
            if appResource.cert_password?.count == 0 {
                appResource.cert_password = ""
            }
            appResource.title = " "
            let res = AppResource(title: appResource.title!, appID: appResource.app_id.uuid!, buildModeID: appResource.build_mode_id.uuid!, cert_password: appResource.cert_password!, resource_link: zip_path, cert_link: cert_path)
            return ENTApplication.find(appResource.app_id.uuid, on: req.db).and(BuildMode.find(appResource.build_mode_id.uuid, on: req.db)).flatMap { (application, buildMode) -> EventLoopFuture<Response> in
                if let a = application, let b = buildMode {
                    res.title = "\(a.name)'s \(b.title) Build Resources"
                }
                return res.save(on: req.db).flatMap { (_) -> (EventLoopFuture<Response>) in
                    return req.save(file: appResource.resources!, path: zip_path).flatMap { (_) -> (EventLoopFuture<Response>) in
                        return req.save(file: appResource.certificate!, path: cert_path).map { (_) -> (Response) in
                            ScriptManager.shared.addScript(script: CertficateScript(resource_id: res.id!.uuidString, certPath: res.cert_link, certPassword: res.cert_password, pulicDir: req.application.directory.publicDirectory))
                            return req.response(status: .accepted, message: "Successfully Added")
                        }
                    }
                }
            }
        } catch (let error) {
            return req.eventLoop.makeSucceededFuture(req.response(status: .badRequest, message: error.description))
        }
    }
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ENTApplication.find(req.parameters.get("entApplicationID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ENTApplication.find(req.parameters.get("entApplicationID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
