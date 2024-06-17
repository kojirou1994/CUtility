// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "CUtility",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(name: "CGeneric", targets: ["CGeneric"]),
    .library(name: "CUtility", targets: ["CUtility"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.0"),
  ],
  targets: [
    .macro(
      name: "CUtilityMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .target(name: "CGeneric", dependencies: ["CUtilityMacros"]),

    .target(name: "CUtility"),
    .target(name: "CTestCode"),
    .testTarget(
      name: "CUtilityTests",
      dependencies: [
        "CUtility",
        "CTestCode",
      ]),
  ]
)
