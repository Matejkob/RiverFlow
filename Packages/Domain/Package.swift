// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "Domain",
      targets: ["Domain"]
    ),
  ],
  targets: [
    .target(
      name: "Domain",
      path: "Sources"
    ),
    .testTarget(
      name: "DomainTests",
      dependencies: ["Domain"],
      path: "Tests"
    ),
  ],
  swiftLanguageModes: [.v6]
)
