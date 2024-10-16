// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "DomainStyling",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "DomainStyling",
      targets: ["DomainStyling"]
    ),
  ],
  dependencies: [
    .package(path: "../Domain")
  ],
  targets: [
    .target(
      name: "DomainStyling",
      dependencies: [
        "Domain"
      ],
      path: "Sources"
    ),
  ],
  swiftLanguageModes: [.v6]
)
