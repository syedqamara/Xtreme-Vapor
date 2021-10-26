import Fluent
import Vapor





func routes(_ app: Application) throws {
    app.sessions.configuration.cookieName = "ent_builds_cookies"
//    app.sessions.configuration.cookieFactory = { sessionID in
//        let obj = HTTPCookies.Value.init(string: sessionID.string, isSecure: true)
//        return obj  
//    }
    app.sessions.use(.fluent)
    let sessionChecked = app.routes.grouped([
        app.sessions.middleware,
        UserAuthTokenSessionAuthenticator(),
        UserAuthToken.sessionAuthenticator(.psql),
    ])
    let protected = app.routes.grouped([
        app.sessions.middleware,
        UserAuthTokenSessionAuthenticator(),
        UserBearerAuthenticator(),
        User.guardMiddleware(),
    ])
    app.get("") { req in
        return req.redirect(to: "web", type: .permanent)
    }
    try app.register(collection: BuildManifestController())
    try app.register(collection: AuthController())
    try sessionChecked.register(collection: WebController())
    try protected.register(collection: AppResourceController())
    try protected.register(collection: UserController())
    try protected.register(collection: RoleController())
    try protected.register(collection: RolePermissionController())
    try protected.register(collection: BuildController())
    try protected.register(collection: BuildAssignmentController())
    try protected.register(collection: BuildNodeController())
    try protected.register(collection: BuildModeController())
    try protected.register(collection: ENTApplicationController())
    try protected.register(collection: PlatformController())
    try protected.register(collection: PermissionController())
    try protected.register(collection: JiraAccountController())
    try protected.register(collection: JiraProjectController())
    try protected.register(collection: JiraIssueTypeController())
    try protected.register(collection: JiraUserController())
    try protected.register(collection: JiraTicketController())
    app.routes.defaultMaxBodySize = "10mb"
}
