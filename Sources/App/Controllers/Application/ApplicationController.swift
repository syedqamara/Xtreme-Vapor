import Fluent
import Vapor

fileprivate let controller_id = "ent_applications"

fileprivate struct ENTAppID: Content {
    var id: String
}

struct ENTApplicationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bs = routes.grouped("api").grouped("\(controller_id)")
        
//        bs.get(use: index)
        bs.post(use: create)
        bs.group(":entApplicationID") { b in
            b.delete(use: delete)
        }
        bs.group("clone") { b in
            b.get(use: clone_repo)
        }
    }
    func clone_repo(req: Request) throws -> EventLoopFuture<String> {
        let app = try req.query.decode(ENTAppID.self)
        return ENTApplication.find(app.id.uuid, on: req.db).map { (application) -> (String) in
            if let a = application {
                
            }
            return ""
        }
    }
    func create(req: Request) throws -> EventLoopFuture<ENTApplication> {
        let b = try req.content.decode(ENTAppCRUD.self)
        let image_path = controller_id+"/"+UUID.init().uuidString + ".png"
        
        let path = image_path
        let fileSaving = req.save(file: b.image, path: path)
        return fileSaving.flatMap { (_) -> (EventLoopFuture<ENTApplication>) in
            let new_app = ENTApplication(name: b.name, bundle_id: b.bundle_id, image_url: image_path, git_url: b.git_url, platformID: b.platform.uuid!, project: b.project, path_to_project: b.path_to_project, target: b.target)
            return new_app.save(on: req.db).map { new_app }
        }
        
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ENTApplication.find(req.parameters.get("entApplicationID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
