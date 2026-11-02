// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "reqmir",
    platforms: [
        .macOS("26.6"),
        // Placeholder until M2 decides which iOS versions ReqmirKit supports.
        .iOS(.v17),
    ],
    products: [
        .library(name: "ReqmirProtocol", targets: ["ReqmirProtocol"]),
        .library(name: "ReqmirKit", targets: ["ReqmirKit"]),
    ],
    targets: [
        .target(name: "ReqmirProtocol"),
        .target(name: "ReqmirKit", dependencies: ["ReqmirProtocol"]),
        .testTarget(name: "ReqmirProtocolTests", dependencies: ["ReqmirProtocol"]),
        .testTarget(name: "ReqmirKitTests", dependencies: ["ReqmirKit"]),
    ]
)
