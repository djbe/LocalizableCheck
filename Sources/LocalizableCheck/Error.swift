//
//  Error.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

enum LocalizableCheckError: LocalizedError {
	case invalidStringsFile(path: Path)
	case missingStringsFile(path: Path?)

	var errorDescription: String? {
		switch self {
		case let .invalidStringsFile(path):
			return "Could not load the translation file \"\(path)\"."
		case let .missingStringsFile(path):
			return "Missing localization file \"\(path ?? "")\"."
		}
	}
}
