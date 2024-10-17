// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "PersistenceStore",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "GRDBTaskRepository",
      targets: ["GRDBTaskRepository"]
    ),
    .library(
      name: "InMemoryTaskRepository",
      targets: ["InMemoryTaskRepository"]
    ),
    .library(
      name: "TaskRepository",
      targets: ["TaskRepository"]
    ),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.29.3")
  ],
  targets: [
    .target(
      name: "GRDBTaskRepository",
      dependencies: [
        "TaskRepository",
        "Domain",
        .product(name: "GRDB", package: "grdb.swift")
      ]
    ),
    .target(
      name: "InMemoryTaskRepository",
      dependencies: [
        "TaskRepository",
        "Domain",
      ]
    ),
    .target(
      name: "TaskRepository",
      dependencies: [
        "Domain",
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
