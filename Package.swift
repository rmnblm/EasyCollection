// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EasyCollection",
    platforms: [
        .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "EasyCollection",
            targets: ["EasyCollection"]
        )
    ],
    targets: [
        .target(
            name: "EasyCollection",
            dependencies: []
        )
    ]
)
