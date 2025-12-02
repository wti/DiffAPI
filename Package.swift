// swift-tools-version: 6.2

import PackageDescription

let name = "DiffAPI"
let syntax = "swift-syntax"
let package = Package(
  name: name,
  platforms: [.macOS(.v10_15)],
  products: [.library(name: name, targets: ["DiffAPI"])],
  dependencies: [
    .package(
      url: "https://github.com/swiftlang/\(syntax).git",
      from: "602.0.0"
    )
  ],
  targets: [  // RUN: DiffAPIDemo
    .target(
      name: name,
      dependencies: [
        .product(name: "SwiftSyntax", package: syntax),
        .product(name: "SwiftParser", package: syntax),
      ]
    ),
    .executableTarget(
      name: "\(name)Demo",
      dependencies: [
        .target(name: name)
      ]
    ),
    .testTarget(
      name: "DiffAPITests",
      dependencies: [
        .target(name: name)
      ]
    ),
  ]
)
