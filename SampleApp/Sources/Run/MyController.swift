import Foundation
import Vapor

private let message = "eAhkbq0exzR3vSuqdKplrRv8P8IDI0LhB87MONLhemkJcutgrzY7iKc8EWt6sHcRRLmrdjUVrvB0Q8zgDk0sSkGdbdSYva7AngwYSUplT5coKfBqF80Ptq2JQ47wuA7nNXgdYdJNEwtSkqxTKjfG8yPeF8Df5cYxvXMRUwW2g2PZhRt8Qw9baFNF9bsLcWZ37iIGxyQVW8ljsT3NnKNPH6N6bmfBgrWzSkmwOnKofClx2tmjycggKBgtqkykGpNtbGlbXt9ynhnTyXQeCEX77tqWKSwqwZ1UZdrRmiwY7iw5Ipg5Oe9SRPuTx1UeZiNKqxAEWWXOPmleQf8LVpOldrhazt2GNHrWeEK7QBDIDT7Hjel31an3iebuxREKi1IKqTJQQ6G0e33ijhbNU3xfMTYNNZdCKJjwtanqTKHXEpHToIcsWvc1cTCAvakVbFm1BzTLxKrUoeLR6X1BIr738vIDRM12K7nw"
    .data(using: .utf8)!

struct MyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("sha512", use: handleSha512)
        routes.get("tarai", use: handleTarai)
    }

    func hashTask<H: HashFunction>(hf: H.Type) -> String {
        var h = hf.init()
        h.update(data: message)

        var current = Data(h.finalize())
        for _ in 0..<1000 {
            var h = hf.init()
            h.update(data: message)
            h.update(data: current)
            current = Data(h.finalize())
        }

        return current.hexEncodedString()
    }

    func handleSha512(req: Request) -> some ResponseEncodable {
        hashTask(hf: SHA512.self)
    }

    func handleTarai(req: Request) -> some ResponseEncodable {
        tarai(x: 12, y: 6, z: 0)
    }

    func tarai(x: Int, y: Int, z: Int) -> Int {
        if x <= y {
            return y
        }
        return tarai(
            x: tarai(x: x - 1, y: y, z: z),
            y: tarai(x: y - 1, y: z, z: x),
            z: tarai(x: z - 1, y: x, z: y)
        )
    }
}
