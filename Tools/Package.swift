// swift-tools-version: 6.4
import PackageDescription

// Kept out of the root Package.swift so that apps depending on ReqmirKit do not inherit SwiftLint.
let package = Package(
    name: "reqmir-tools",
    platforms: [.macOS("26.6")],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.65.1")
    ],
    targets: []
)
