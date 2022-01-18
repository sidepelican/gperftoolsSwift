import Foundation
import gperftoolsSwift
import Vapor

let app = Application()

let profilePath = NSTemporaryDirectory() + "a.profile"

app.get("profile") { (req) -> EventLoopFuture<Response> in
    let waitSecond = min((try? req.query.get(TimeInterval.self, at: "s")) ?? 30, 120)
    Profiler.start(fname: profilePath)

    let promise = req.eventLoop.makePromise(of: Response.self)
    DispatchQueue.global().asyncAfter(deadline: .now() + waitSecond) {
        Profiler.stop()
        let res = req.fileio.streamFile(at: profilePath)
        promise.completeWith(.success(res))
    }
    return promise.futureResult
}

app.get("profile_start") { (req) -> String in
    Profiler.start(fname: profilePath)
    return "start!"
}

app.get("profile_end") { (req) -> Response in
    Profiler.stop()
    return req.fileio.streamFile(at: profilePath)
}

app.get("binary") { (req) -> Response in
    return req.fileio.streamFile(at: ProcessInfo.processInfo.arguments[0])
}

try app.register(collection: MyController())
try app.run()
