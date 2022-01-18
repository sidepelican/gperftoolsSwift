import Foundation
import gperftoolsSwift
import Vapor

let app = Application()

app.get("profile") { (req) -> EventLoopFuture<Response> in
    let result = NSTemporaryDirectory() + "a.profile"
    let waitSecond = min((try? req.query.get(TimeInterval.self, at: "s")) ?? 30, 120)
    Profiler.start(fname: result)

    let promise = req.eventLoop.makePromise(of: Response.self)
    DispatchQueue.global().asyncAfter(deadline: .now() + waitSecond) {
        Profiler.stop()
        let res = req.fileio.streamFile(at: result)
        promise.completeWith(.success(res))
    }
    return promise.futureResult
}

try app.register(collection: MyController())
try app.run()
