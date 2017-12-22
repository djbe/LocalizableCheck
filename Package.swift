// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "LocalizableCheck",
	dependencies: [
//		.package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
		.package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
		.package(url: "https://github.com/sharplet/Regex.git", from: "1.1.0"),
	],
	targets: [
		.target(
			name: "LocalizableCheck",
			dependencies: [
				"PathKit",
				"Regex"
			]
		)
	]
)
