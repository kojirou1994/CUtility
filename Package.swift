// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "CUtility",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(name: "CGeneric", targets: ["CGeneric"]),
    .library(name: "CUtility", targets: ["CUtility"]),
    .library(name: "CUtilityDarwin", targets: ["CUtilityDarwin"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "601.0.1"),
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

    .target(
      name: "CUtility",
      swiftSettings: [
        .enableExperimentalFeature("Lifetimes"),
      ],
    ),
    .target(name: "CUtilityDarwin", dependencies: ["CUtility"]),
    .target(name: "CTestCode"),
    .testTarget(
      name: "CUtilityTests",
      dependencies: [
        "CUtility",
        "CTestCode",
      ]),
  ]
)
