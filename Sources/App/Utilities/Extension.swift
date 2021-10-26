import Fluent
import Vapor

extension String {
    var uuid: UUID? {
        return UUID(uuidString: self)
    }
    mutating func replace(str: String, with str2: String) {
        self = self.replacingOccurrences(of: str, with: str2)
    }
    var base64Encoded: String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
extension MultipartKit.MultipartError {
    
}
extension Error {
    var description: String {
        if let e = self as? MultipartKit.MultipartError {
            return e.description
        }
        return self.localizedDescription
    }
}

extension Request {
    func response(status: HTTPResponseStatus, message: String) -> Response {
        return Response(status: status, version: self.version, headers: self.headers, body: Response.Body(string: message))
    }
    func save(file: File, path: String) -> EventLoopFuture<String> {
        let finalPath = self.application.directory.publicDirectory + path
        return self.application.fileio.openFile(path: finalPath,
                                                         mode: .write,
                                                         flags: .allowFileCreation(posixMode: 0x744),
                                                         eventLoop: self.eventLoop)
            .flatMap { handle in
                self.application.fileio.write(fileHandle: handle,
                                             buffer: file.data,
                                             eventLoop: self.eventLoop)
                    .flatMapThrowing { _ -> String in
                        try handle.close()
                        return file.filename
                    }
            }
    }
    func webToAppRest(url: URI, method: HTTPMethod, body: ByteBuffer?) -> EventLoopFuture<ClientResponse>? {
        if self.hasSession {
            let session = self.session.data["_UserAuthTokenSession"]
            let user = UserAuthToken()
            user.id = UUID.init(uuidString: session ?? "")
            self.session.authenticate(user)
            guard let token = self.auth.get(UserAuthToken.self) else {
                return nil
            }
            var header = self.headers
            header.add(name: "Authorization", value: "Bearer "+token.value)
            var client: EventLoopFuture<ClientResponse>?
            if method == .POST {
                client = self.client.post(url, headers: header) { (requestBefore) in
                    guard let b = body else {return}
                    requestBefore.body = b
                    print("Body Param Inserted")
                }
            }
            else if method == .GET {
                client = self.client.get(url, headers: header) { (requestBefore) in
                    print("Befoore Request is initiating")
                }
            }
            if let c = client {
                return c
            }
        }
        return nil
    }
    func webToApi<T: Content>(url: URI, method: HTTPMethod, body: T?) -> EventLoopFuture<ClientResponse>? {
        if self.hasSession {
            let session = self.session.data["_UserAuthTokenSession"]
            let user = UserAuthToken()
            user.id = UUID.init(uuidString: session ?? "")
            self.session.authenticate(user)
            guard let token = self.auth.get(UserAuthToken.self) else {
                return nil
            }
            var header = self.headers
            header.add(name: "Authorization", value: "Bearer "+token.value)
            var client: EventLoopFuture<ClientResponse>?
            if method == .POST {
                client = self.client.post(url, headers: header) { (requestBefore) in
                    guard let b = body else {return}
                    do {
                        try requestBefore.content.encode(b, as: .json)
                    }
                    catch let err {
                        print("Body Encoding Error \(err)")
                    }
                    
                }
            }
            else if method == .GET {
                client = self.client.get(url, headers: header) { (requestBefore) in
                    print("Befoore Request is initiating")
                }
            }
            if let c = client {
                return c
            }
        }
        return nil
    }
    func webToJiraRest(url: URI, token: String, method: HTTPMethod, body: ByteBuffer?) -> EventLoopFuture<ClientResponse>? {
        var header = HTTPHeaders([])
        header.add(name: "Authorization", value: "Basic " + token)
        header.add(name: "Content-Type", value: "application/json")
        var client: EventLoopFuture<ClientResponse>?
        if method == .POST {
            client = self.client.post(url, headers: header) { (requestBefore) in
                requestBefore.body = body
                print("Befoore Request is initiating")
            }
        }
        else if method == .GET {
            client = self.client.get(url, headers: header) { (requestBefore) in
                print("Befoore Request is initiating")
            }
        }
        if let c = client {
            return c
        }
        return nil
    }
}
