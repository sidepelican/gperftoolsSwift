// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "gperftoolsSwift",
    products: [
        .library(name: "gperftoolsSwift", targets: ["gperftoolsSwift"]),
    ],
    targets: [
        .target(
            name: "gperftoolsSwift",
            dependencies: [
                "Cgperftools",
            ]
        ),
        .systemLibrary(
            name: "Cgperftools",
            pkgConfig: "libprofiler",
            providers: [
                .brew(["gperftools"]),
                .apt(["libgoogle-perftools-dev"]),
            ]
        ),
    ]
)
