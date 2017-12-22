//
//  InterfaceBuilderStrings.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

private extension Path {
	private static let ibExtensions = ["storyboard", "xib"]

	var ibFiles: [Path] {
		return ((try? children()) ?? []).filter {
			Path.ibExtensions.contains($0.extension ?? "")
		}
	}

	var correspondingStringsFile: Path {
		return parent() + "\(lastComponentWithoutExtension).strings"
	}

	var lastChanged: Date {
		guard let attributes = try? FileManager.default.attributesOfItem(atPath: string),
			let date = attributes[.modificationDate] as? Date else { return Date(timeIntervalSince1970: 0) }
		return date
	}
}

func exportStringsFile(to stringsFile: Path, from ibFile: Path) -> Bool {
	let tmpFile = Path.temporary + UUID().uuidString
	defer {
		try? tmpFile.delete()
	}

	let exportResult = Command.run(
		command: "/usr/bin/ibtool",
		arguments: ["--export-strings-file", tmpFile.string, ibFile.string]
	)
	guard exportResult.exitCode == 0 else { return false }

	let conversionResult = Command.run(
		command: "/usr/bin/iconv",
		arguments: ["-f", "UTF-16", "-t", "UTF-8", tmpFile.string]
	)

	do {
		try stringsFile.write(conversionResult.output)
	} catch {
		return false
	}
	return true
}

func updateStoryboardStrings(in resources: Resources, placeholder: String?) throws {
	guard let base = resources.base else { return }

	// iterate over files
	for item in base.ibFiles {
		let itemBaseStringsPath = item.correspondingStringsFile

		// generate strings file if needed
		if !itemBaseStringsPath.exists || item.lastChanged > itemBaseStringsPath.lastChanged {
			guard exportStringsFile(to: itemBaseStringsPath, from: item) else {
				warn(file: item, msg: "Couldn't extract strings from IB file.")
				continue
			}
		}
		guard let itemBaseStrings = StringsFile(path: itemBaseStringsPath) else {
			throw LocalizableCheckError.missingStringsFile(path: item)
		}

		// update strings in each locale
		for translatedPath in resources.findAllLocales(for: itemBaseStringsPath) {
			if !translatedPath.exists {
				try itemBaseStringsPath.copy(translatedPath)
			} else if let translated = StringsFile(path: translatedPath) {
				try translated.incrementallyUpdateKeys(with: itemBaseStrings, placeholder: placeholder)
			} else {
				throw LocalizableCheckError.missingStringsFile(path: translatedPath)
			}
		}
	}
}
