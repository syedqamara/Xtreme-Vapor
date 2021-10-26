import Fluent
import Vapor

enum BuildStatus: String {
    case process = "processing"
    case success = "success"
    case failure = "failure"
}

struct BuildController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bs = routes.grouped("api").grouped("builds")
        bs.get(use: index)
        bs.post(use: create)
        bs.post("update", use: update)
        bs.group(":buildID") { b in
            b.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Build]> {
        return Build.query(on: req.db).all()
    }
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let dict = try req.content.decode([String: String].self)
        print("Update Build Params\n\(dict)")
        let newBuild = try req.content.decode(Build.Update.self)
        return Build.find(newBuild.id.uuid!, on: req.db).flatMap { (buildObj) -> EventLoopFuture<HTTPStatus> in
            if let b = buildObj {
                if let value = newBuild.build_link {
                    b.build_link = value
                }
                if let value = newBuild.build_status {
                    b.build_status = value
                }
                return b.update(on: req.db).map { (_) -> (HTTPStatus) in
                    return HTTPStatus.ok
                }
                
            }
            return req.eventLoop.makeSucceededFuture(HTTPStatus.notFound)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Build> {
        let token = req.headers.bearerAuthorization?.token
        
        let newBuild = try req.content.decode(Build.Create.self)
        let b = Build(git_branch: newBuild.git_branch, build_link: "", script_log_file_path: "", buildModeID: newBuild.build_mode_id.uuid!, buildNodeID: newBuild.build_node_id.uuid!, appID: newBuild.app_id.uuid!, build_expire_date: Date(), release_notes: newBuild.release_notes, build_status: BuildStatus.process.rawValue)
        
        return b.save(on: req.db).flatMap { (_) -> EventLoopFuture<Build> in
            return Build.query(on: req.db).filter(\.$id == b.id!).with(\.$application).with(\.$build_mode).first().map { (buildObj) -> (Build) in
                DispatchQueue.global().async {
                    let script = BuildScript(git: buildObj!.application.git_url, branch: buildObj!.git_branch, build_id: buildObj!.id!.uuidString, build_mode: buildObj!.build_mode.identifier, pod: "install", token: token!, public_dir: req.application.directory.publicDirectory, app_id: buildObj!.application.id!.uuidString)
                    ScriptManager.shared.addScript(script: script)
                }
                return buildObj!
            }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Build.find(req.parameters.get("buildID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
