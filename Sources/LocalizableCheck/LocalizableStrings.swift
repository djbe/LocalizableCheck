//
//  LocalizableStrings.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

private extension Path {
	var localizableStrings: Path {
		return self + "Localizable.strings"
	}
}

private func findOriginalStringsTable(in resources: Resources) -> Path? {
	if let base = resources.base?.localizableStrings, base.exists {
		return base
	} else {
		return resources.english?.localizableStrings
	}
}

// Check Localizable.strings files in Resources folder
func checkLocalizable(in resources: Resources) throws {
	// load the original localization
	guard let original = findOriginalStringsTable(in: resources),
		let source = StringsFile(path: original) else {
			throw LocalizableCheckError.missingStringsFile(path: resources.english)
	}

	// iterate over the other languages
	for locale in resources.findAllLocales(for: original) {
		guard let translation = StringsFile(path: locale) else {
			throw LocalizableCheckError.missingStringsFile(path: locale)
		}

		try source.compare(with: translation)
	}
}
