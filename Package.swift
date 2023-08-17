// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncSequence",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .executable(
            name: "AsyncSequenceClient",
            targets: ["AsyncSequenceClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(name: "AsyncSequenceClient",
                          dependencies: [.product(name: "AsyncAlgorithms", package: "swift-async-algorithms")])
    ]
)
