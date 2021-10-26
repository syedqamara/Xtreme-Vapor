import Fluent
import Vapor

extension RoutesBuilder {
    func authProtectedRoute(_ redirect_url: String) -> RoutesBuilder {
        return self.grouped(UserAuthToken.redirectMiddleware(path: redirect_url))
    }
}

struct WebController: RouteCollection, WebControllerAuthentication, WebControllerApplication, WebControllerBuilds, WebControllerAppResources, WebControllerJira {
    func boot(routes: RoutesBuilder) throws {
        web(routes.grouped("web"))
    }
    func web(_ routes: RoutesBuilder) {
        ///Protected Routes means all end_points fall under this will required Authenticated User
        let protectedRoutes = routes.authProtectedRoute("/web?loginRequired=true")
        auth(routes)
        jira(protectedRoutes)
        apps(protectedRoutes)
        builds(protectedRoutes)
        appResource(protectedRoutes)
    }
}
