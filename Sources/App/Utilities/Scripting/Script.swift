//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 07/04/2021.
//

import Fluent
import Vapor

protocol Script {
    var script: String {get}
    var script_directory_path: String {get}
    var script_log_path: String {get}
    func didExecuted(application: Application)
}

extension Script {
    func didExecuted(application: Application) {}
    func run(on application: Application, logPath: String) -> EventLoopFuture<String> {
        return self.execute(script_name: self.script, path: application.directory.publicDirectory+self.script_directory_path, app: application).flatMap { scriptLog -> EventLoopFuture<String> in
            let path = application.directory.publicDirectory + logPath + "/\(Date().timeIntervalSince1970).log"
            guard let data = scriptLog.data(using: .utf8) else {return application.eventLoopGroup.future(script)}
            let bufferByte = ByteBuffer(data: data)
            let eventLoop = application.eventLoopGroup.next()
            return application.fileio.openFile(path: path,
                                                             mode: .write,
                                                             flags: .allowFileCreation(posixMode: 0x744),
                                                             eventLoop: eventLoop)
                .flatMap { handle in
                    application.fileio.write(fileHandle: handle,
                                                 buffer: bufferByte,
                                                 eventLoop: eventLoop)
                        .flatMapThrowing { _ -> String in
                            try handle.close()
                            return ""
                        }
                }
        }
    }
    fileprivate func execute(script_name: String, path: String, app: Application) -> EventLoopFuture<String> {
        let event = app.eventLoopGroup.next()
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            let pipe = Pipe()
            let errorPipe = Pipe()
            task.standardOutput = pipe
            task.standardError = errorPipe
            task.arguments = ["-c", script_name]
            task.currentDirectoryPath = path
            task.launchPath = "/bin/zsh"
            pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            pipe.fileHandleForReading.readabilityHandler = { newPipe in
                if newPipe.availableData.count > 0 {
                    if let line = String.init(data: newPipe.availableData, encoding: .utf8) {
                        // Update your view with the new text here
                        print("⏩: \(line)")
                    } else {
                        print("🚫 Command Execution Failed")
                    }
                }
            }
            errorPipe.fileHandleForReading.readabilityHandler = { newPipe in
                if newPipe.availableData.count > 0 {
                    if let line = String.init(data: newPipe.availableData, encoding: .utf8) {
                        // Update your view with the new text here
                        print("⏩: \(line)")
                    } else {
                        print("🚫 Command Execution Failed")
                    }
                }
            }
            task.launch()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            let resp = "Script:\n\n\(script)\n\nOutput:\n\n"+output
            event.makeSucceededFuture(resp)
        }
        
        
        let finalResult = event.makePromise(of: String.self).futureResult
        return finalResult
    }
    func output() {
        
    }
}
