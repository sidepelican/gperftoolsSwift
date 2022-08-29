# gperftoolsSwift

CPU profiling of Swift on server.

# Install

- Package.swift

```.swift
.package(url: "https://github.com/sidepelican/gperftoolsSwift.git", from: "0.1.0"),

...

.executableTarget(
    dependencies: [
        ...
        "gperftoolsSwift",
    ]
),
```

# Profile

gperftoolsSwift is very thin wrapper of gperftools. To start and stop profiling, call `Profiler.start` and `Profiler.stop` static function.

```swift
import gperftoolsSwift

let file = NSTemporaryDirectory() + "a.profile"
Profiler.start(fname: file)
// do something
Profiler.stop()
```

A report file is written to `<tmp>/a.profile` .

If you are using Vapor web framework, you can add utility endpoint like below.

```swift
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

app.get("binary") { (req) -> Response in
    return req.fileio.streamFile(at: ProcessInfo.processInfo.arguments[0])
}
```

To start profiling and get the report, call `/profile` from another terminal.

```sh
wget http://localhost:3000/profile?s=60
```

`/binary` is also useful to have for later visualization.

# Visualize

`pprof` is useful to visualize. Install it via golang.

```sh
go install github.com/google/pprof@latest
```

(maybe you also need to install graphviz. `brew install graphviz`. )


To visualize the profile results, use the following command with the executable binary.

```sh
pprof -http=":" <executable binary file> <report file>
```

`pprof` has many options to visualize reports. see [doc](https://github.com/google/pprof/blob/main/doc/README.md#text-reports).

![Frame Graph](https://user-images.githubusercontent.com/19257572/187181881-d3abd4f7-d2cb-486c-8ebe-ca6ec6e4e428.png)


