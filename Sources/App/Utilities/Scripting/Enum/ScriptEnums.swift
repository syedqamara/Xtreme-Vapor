//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 20/04/2021.
//

import Foundation

enum ScripLogPath: String {
    case clone = "script_logs/clones"
    case build = "script_logs/builds"
    case certificate = "script_logs/certificates"
}
enum ScriptPrefix: String {
    case build = "chmod 777 checkout.sh && ./checkout.sh"
    case clone = "chmod 777 clone.sh && ./clone.sh"
    case certificate = "chmod 777 certificate.sh && ./certificate.sh"
}
enum PublicDirectory: String {
    case repositories = "repositories"
    case scripts = "scripts"
    case assets = "assets"
    case script_logs = "script_logs"
}
