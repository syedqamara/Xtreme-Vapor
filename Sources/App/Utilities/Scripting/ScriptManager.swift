//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 20/04/2021.
//

import Vapor
import Fluent

final class ScriptManager {
    fileprivate var concurrentScriptExecutionLimit = 10
    fileprivate var scripts = [Script]()
    fileprivate var executing_scripts = [Script]()
    var app: Application!
    fileprivate init() {}
    static let shared = ScriptManager()
    func addScript(script: Script) {
        app.threadPool.runIfActive(eventLoop: app.eventLoopGroup.next()) { () -> Void in
            self.scripts.append(script)
            self.checkAndExecute()
            return
        }
    }
    fileprivate func checkAndExecute() {
        if executing_scripts.count < concurrentScriptExecutionLimit, scripts.count > 0 {
            let script = self.scripts.removeFirst()
            self.executing_scripts.append(script)
            script.run(on: self.app, logPath: script.script_log_path).map { (_) -> (Void) in
                self.remove(script)
                return
            }
        }
    }
    fileprivate func remove(_ script: Script) {
        executing_scripts.removeAll { (s) -> Bool in
            return script.script == s.script
        }
        checkAndExecute()
        script.didExecuted(application: app)
    }
}
