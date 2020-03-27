// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Session",
    products: [
        .library(name: "Session", targets: ["Session"])
    ],
    targets: [
        .target(name: "Session", dependencies: []),
        .testTarget(name: "SessionTests", dependencies: ["Session"])
    ]
)
