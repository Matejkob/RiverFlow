// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "LocalNotificationsService",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
        name: "LocalNotificationsService",
        targets: ["LocalNotificationsService"]
    ),
    .library(
        name: "UILocalNotificationsService",
        targets: ["UILocalNotificationsService"]
    ),
  ],
  dependencies: [
    .package(path: "../Domain"),
  ],
  targets: [
    .target(
        name: "LocalNotificationsService",
        dependencies: [
          "Domain"
        ]
    ),
    .target(
      name: "UILocalNotificationsService",
      dependencies: [
        "Domain",
        "LocalNotificationsService"
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
