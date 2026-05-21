// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-workshop",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "WorkshopFeedbin",
      targets: ["WorkshopFeedbin"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/dirtyhenry/swift-blocks",
      .upToNextMinor(from: "0.10.0")
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.19.2"
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "WorkshopFeedbin",
      dependencies: [
        .product(name: "Blocks", package: "swift-blocks")
      ]
    ),
    .testTarget(
      name: "WorkshopFeedbinTests",
      dependencies: [
        "WorkshopFeedbin",
        .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
