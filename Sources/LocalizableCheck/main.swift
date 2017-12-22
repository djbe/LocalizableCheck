//
//  main.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

enum Parameters {
	static let placeholder = "--placeholder"
}

var arguments = ProcessInfo.processInfo.arguments

// TODO: replace this with Commander
var placeholder: String? = nil
if let index = arguments.index(of: Parameters.placeholder)?.advanced(by: 1), index < arguments.endIndex {
	placeholder = arguments[index]
	arguments.remove(at: index)
	arguments.remove(at: index - 1)
}

guard arguments.count == 2, let path = arguments.last else {
	errorOut("Must be called with at least the path to the \"Resources\" folder, and an optional placeholder parameter.")
}

do {
	let resources = Resources(path: path)
	if let placeholder = placeholder {
		print("Placeholder: \"\(placeholder)\"")
	} else {
		print("No placeholder set, using base values.")
	}

	print()
	print("### Checking Localizable.strings files ###")
	try checkLocalizable(in: resources)
	print("Done!")

	print()
	print("### Updating Base Internationalization strings files ###")
	try updateStoryboardStrings(in: resources, placeholder: placeholder)
	print("Done!")
} catch let error {
	errorOut(error.localizedDescription)
}

exit(EXIT_SUCCESS)
