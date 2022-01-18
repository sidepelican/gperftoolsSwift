import Cgperftools
import Foundation

public struct Profiler {
    public static func start(fname: String) {
        fname.withCString {
            _ = ProfilerStart($0)
        }
    }

    public static func stop() {
        ProfilerStop()
    }
}
