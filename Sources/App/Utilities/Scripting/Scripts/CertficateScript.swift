
import Vapor
import Fluent


struct CertficateScript: Script {
    var resource_id: String
    var certPath: String
    var certPassword: String
    var pulicDir: String
    var script: String {
        return ScriptPrefix.certificate.rawValue + " \(self.pulicDir + self.certPath) \(self.certPassword)"
    }
    var script_log_path: String {
        return ScripLogPath.certificate.rawValue
    }
    var script_directory_path: String {
        return PublicDirectory.scripts.rawValue
    }
    
}
//security import ./ENTERTAINER.p12 -P 1111 -A
