import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

struct AppConfig {
    static let isLocalDB = false
    static let baseURL = "http://127.0.0.1:8080/"
    static let jiraBaseURL = "https://entertainerproducts.atlassian.net/rest/api/2/"
}





//enum ENTBuildsDB: String {
//    typealias RawValue = String
//    case db_name = "uat_builds"
//    case hostname = "localhost"
//    case username = "postgres"
//    case password = ""
// }
//postgres://uopczrtspxvnfp:0338f4911a02d17aaef20c4abe84e3cb026119a1b2b8b94de2a37266fa411ad8@ec2-52-71-161-140.compute-1.amazonaws.com:5432/d29gg198bn81tt
enum ENTBuildsDB: String {
    typealias RawValue = String
    case db_name = "d29gg198bn81tt"
    case hostname = "ec2-52-71-161-140.compute-1.amazonaws.com"
    case username = "uopczrtspxvnfp"
    case password = "0338f4911a02d17aaef20c4abe84e3cb026119a1b2b8b94de2a37266fa411ad8"
    case db_url = "postgres://uopczrtspxvnfp:0338f4911a02d17aaef20c4abe84e3cb026119a1b2b8b94de2a37266fa411ad8@ec2-52-71-161-140.compute-1.amazonaws.com:5432/d29gg198bn81tt"
 }

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    ScriptManager.shared.app = app
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if AppConfig.isLocalDB {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? ENTBuildsDB.hostname.rawValue,
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? ENTBuildsDB.username.rawValue,
            password: Environment.get("DATABASE_PASSWORD") ?? ENTBuildsDB.password.rawValue,
            database: Environment.get("DATABASE_NAME") ?? ENTBuildsDB.db_name.rawValue
        ), as: .psql)
    }else {
        if var postgresConfig = PostgresConfiguration(url: ENTBuildsDB.db_url.rawValue) {
            postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
            app.databases.use(.postgres(
                configuration: postgresConfig
            ), as: .psql)
        }
    }
    
    
    
    
    app.views.use(.leaf)
    app.migrations.add(SessionRecord.migration)
    JiraAccount.migrations(app)
    JiraProject.migrations(app)
    JiraIssueType.migrations(app)
    JiraUser.migrations(app)
    JiraTicket.migrations(app)
    Role.migrations(app)
    User.migrations(app)
    UserAuthToken.migrations(app)
    Permission.migrations(app)
    RolePermission.migrations(app)
    BuildNode.migrations(app)
    AppResource.migrations(app)
    BuildMode.migrations(app)
    ENTApplication.migrations(app)
    Platform.migrations(app)
    Build.migrations(app)
    BuildAssignment.migrations(app)
    // register routes
    try routes(app)
}
