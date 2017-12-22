//
//  Resources.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

//enum Resources {
//	static let baseBundle: Path = "Base.lproj"
//	static let englishBundle: Path = "en.lproj"
//	static let localizableStrings: Path = "Localizable.strings"
//
//}

final class Resources {
	enum Constants {
		static let base = "Base"
		static let english = "en"
		static let bundleExtension = "lproj"
	}

	let path: Path

	init(path: String) {
		self.path = Path(path)
	}

	subscript(language: String) -> Path? {
		let path = self.path + "\(language).\(Constants.bundleExtension)"

		if path.exists && path.isDirectory {
			return path
		} else {
			return nil
		}
	}

	// MARK: - Bundles

	private lazy var bundles: [Path] = {
		return ((try? self.path.children()) ?? []).filter {
			$0.extension == Constants.bundleExtension
		}
	}()

	private(set) lazy var localizableStringsBundles: [Path] = {
		let except = [Constants.base, Constants.english]
		return bundles.filter {
			!except.contains($0.lastComponentWithoutExtension)
		}
	}()

	private(set) lazy var bundlesExceptBase: [Path] = {
		return self.bundles.filter {
			$0.lastComponentWithoutExtension != Constants.base
		}
	}()

	func findAllLocales(for file: Path) -> [Path] {
		return bundles
			.filter { $0 != file.parent() && $0.lastComponentWithoutExtension != Constants.base }
			.map { $0 + file.lastComponent }
	}

	private(set) lazy var base: Path? = self[Constants.base]
	private(set) lazy var english: Path? = self[Constants.english]
}
