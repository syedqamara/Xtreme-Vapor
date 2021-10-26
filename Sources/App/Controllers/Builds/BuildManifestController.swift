//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 19/04/2021.
//

import Vapor
import Fluent



struct BuildManifestController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bs = routes.grouped("api").grouped("build_manifest")
        bs.post(use: index)
    }

    func index(req: Request) throws -> EventLoopFuture<String> {
        let dict = try req.content.decode([String: String].self)
        print("Manifest Creation Params\n\(dict)")
        let b = try req.content.decode(Build.Manifest.self)
        return Build.query(on: req.db).filter(\.$id == b.id.uuid!).first().flatMapThrowing { (buildObj) -> String in
            if let build = buildObj {
                let manifest = Build.BuildManifest(manifest: b, build: build)
                let plist = manifest.plist()
                if !plist.isEmpty {
                    return plist
                }
            }
            throw Abort.init(HTTPResponseStatus.noContent)
        }
    }
}

