// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AdmobSwiftUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "AdmobSwiftUI",
            targets: ["AdmobSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "10.14.0")
    ],
    targets: [
        .target(
            name: "AdmobSwiftUI",
            dependencies: [
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads",
                    condition: .when(platforms: [.iOS])
                ),
            ]
        ),
    ]
)
