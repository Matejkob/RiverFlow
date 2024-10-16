// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "TaskFeature",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "TaskFeature",
      targets: ["TaskFeature"]
    ),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(path: "../DomainStyling"),
    .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.5.6"),
    .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.2.2"),
  ],
  targets: [
    .target(
      name: "TaskFeature",
      dependencies: [
        "Domain",
        "DomainStyling",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "SwiftUINavigation", package: "swift-navigation"),
      ],
      path: "Sources"
    ),
    .testTarget(
      name: "TaskFeatureTests",
      dependencies: ["TaskFeature"],
      path: "Tests"
    ),
  ],
  swiftLanguageModes: [.v6]
)
