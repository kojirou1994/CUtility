// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "CUtility",
  products: [
    .library(name: "CUtility", targets: ["CUtility"]),
  ],
  targets: [
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
