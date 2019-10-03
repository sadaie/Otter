// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Otter",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Otter",
            targets: ["Otter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.9.0"),
        .package(url: "https://github.com/google/promises.git", from: "1.2.8"),
    ],
    targets: [
        .target(
            name: "Otter",
            dependencies: [
                "Alamofire",
                "Promises",
            ]
        ),
        .testTarget(
            name: "OtterTests",
            dependencies: ["Otter"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
