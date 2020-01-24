// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorUp",
    dependencies: [
        .package(url: "https://github.com/johnsundell/files.git",from: "4.1.1"),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.0.1")
    ],
    targets: [
        .target(name: "ColorUp", dependencies: ["ColorUpCore"]),
        .target(name: "ColorUpCore", dependencies: ["Files", "SwiftToolsSupport"]),
        .testTarget(name: "ColorUpTests", dependencies: ["Files", "SwiftToolsSupport"])
    ]
)
