// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FootballDataClient",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "FootballDataClient",
            targets: ["FootballDataClient"]
        ),
        .library(
            name: "FootballDataClientType",
            targets: ["FootballDataClientType"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Thieurom/Pilot", from: "0.4.0")
    ],
    targets: [
        .target(
            name: "FootballDataClient",
            dependencies: [
                "FootballDataClientType",
                .product(name: "Pilot", package: "Pilot")
            ]
        ),
        .target(
            name: "FootballDataClientType",
            dependencies: []
        ),
        .testTarget(
            name: "FootballDataClientTests",
            dependencies: [
                "FootballDataClient",
                .product(name: "PilotTestSupport", package: "Pilot")
            ]
        )
    ]
)
