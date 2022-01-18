// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SampleApp",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(name: "gperftoolsSwift", path: "./.."),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.54.1"),
    ],
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: [
                "gperftoolsSwift",
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)
