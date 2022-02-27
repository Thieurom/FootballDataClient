// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FootballDataClient",
    products: [
        .library(
            name: "FootballDataClient",
            targets: ["FootballDataClient"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FootballDataClient",
            dependencies: []),
        .testTarget(
            name: "FootballDataClientTests",
            dependencies: ["FootballDataClient"]),
    ]
)
