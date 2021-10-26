//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 19/04/2021.
//

import Vapor
//./checkout.sh https://github.com/syedqamara/QUGenderView.git master 123456789 enterprise install cVdxqTL71LpuxbEQr390/9nVq+cQb6Pxe9QICoM69q+ompa3NoGkhMFvb0AhwMF46/yJ2g== /Users/syedqamarabbas/Xtreme-Vapor/Xtreme-Vapor/Public

struct BuildScript: Codable, Script {
    let git: String
    let branch: String
    let build_id: String
    let build_mode: String
    let pod: String
    let token: String
    let public_dir: String
    let app_id: String
    
    var script: String {
        let actualCommand = "cd \(self.public_dir)/\(script_directory_path) && \(ScriptPrefix.build.rawValue)  \(git) \(branch) \(build_id) \(build_mode) \(pod) \(token) \(public_dir) \(app_id) \(PublicDirectory.repositories.rawValue)"
        let finalScript = "osascript -e \'tell application \"Terminal\" to do script \"\(actualCommand)\"\'"
        return finalScript
    }
    var script_log_path: String {
        return ScripLogPath.build.rawValue
    }
    var script_directory_path: String {
        return PublicDirectory.scripts.rawValue
    }
}
