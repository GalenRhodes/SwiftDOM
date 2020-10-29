// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftDOM",
  platforms: [ .macOS(.v10_15), .tvOS(.v13), .iOS(.v13), .watchOS(.v6) ],
  products: [
      .library(name: "SwiftDOM", targets: [ "SwiftDOM" ]),
  ],
  dependencies: [
      .package(name: "Rubicon", url: "https://github.com/GalenRhodes/Rubicon", from: "0.2.33"),
  ],
  targets: [
      .target(name: "SwiftDOM", dependencies: [ "Rubicon" ]),
      .testTarget(name: "SwiftDOMTests", dependencies: [ "SwiftDOM" ]),
  ]
)
