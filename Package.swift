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
      .package(name: "Rubicon", url: "https://github.com/GalenRhodes/Rubicon", from: "0.2.36"),
      .package(name: "LibXML2Helper", url: "https://github.com/GalenRhodes/LibXML2Helper", from: "1.1.0"),
  ],
  targets: [
      //.systemLibrary(name: "LibXML2", pkgConfig: "libxml-2.0", providers: [ .apt([ "libxml2-dev" ]) ]),
      //.target(name: "SwiftDOM", dependencies: [ "Rubicon", "LibXML2" ]),
      .target(name: "SwiftDOM", dependencies: [ "Rubicon", "LibXML2Helper" ]),
      .testTarget(name: "SwiftDOMTests", dependencies: [ "SwiftDOM" ]),
  ]
)
