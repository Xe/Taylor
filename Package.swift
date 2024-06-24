// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Taylor",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftcordApp/DiscordKit", branch: "main"),
        .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
        .package(url: "https://github.com/kevinhermawan/OllamaKit.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Taylor",
            dependencies: [
                .product(name: "DiscordKitBot", package: "DiscordKit"),
                .product(name: "DotEnv", package: "DotEnv"),
                .product(name: "OllamaKit", package: "OllamaKit"),
            ],
            path: "Sources"),
    ]
)
