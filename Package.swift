// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "CUtility",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(name: "SwiftFix", targets: ["SwiftFix"]),
    .library(name: "CStringInterop", targets: ["CStringInterop"]),
    .library(name: "CUtility", targets: ["CUtility"]),
    .library(name: "CUtilityDarwin", targets: ["CUtilityDarwin"]),
    .library(name: "SyscallValue", targets: ["SyscallValue"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "SwiftFix"),
    .target(
      name: "CStringInterop",
      dependencies: ["SwiftFix"],
      swiftSettings: [
        .enableExperimentalFeature("Lifetimes"),
      ],
    ),
    .target(
      name: "CUtility",
      dependencies: ["CStringInterop"],
      swiftSettings: [
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
    .target(name: "SyscallValue", dependencies: ["CUtility"]),
    .testTarget(
      name: "SyscallValueTests",
      dependencies: ["SyscallValue"]),
  ]
)
