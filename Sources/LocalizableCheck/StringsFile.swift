//
//  StringsFile.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit
import Regex

final class StringsFile {
	typealias StringTable = [String: String]

	let path: Path
	private var content: StringTable? = nil
	private var comments: StringTable? = nil

	init?(path: Path) {
		guard path.exists && path.isFile else { return nil }
		self.path = path
	}

	private var keys: Set<String> {
		guard let content = content else { return Set() }
		return Set(content.keys)
	}
}

extension StringsFile: Equatable {
	static func ==(lhs: StringsFile, rhs: StringsFile) -> Bool {
		return lhs.keys == rhs.keys
	}
}

// MARK: - Comparison between strings files

extension StringsFile {
	private func loadContentIfNeeded() throws {
		guard content == nil else { return }

		guard let content = NSDictionary(contentsOf: path.url) as? StringTable else {
			throw LocalizableCheckError.invalidStringsFile(path: path)
		}
		self.content = content
	}

	func compare(with file: StringsFile) throws {
		try loadContentIfNeeded()
		try file.loadContentIfNeeded()

		for item in keys.subtracting(file.keys) {
			warn(file: file.path, msg: "Missing key: \(item)")
		}
		for item in file.keys.subtracting(keys) {
			warn(file: file.path, msg: "Extraneous key: \(item)")
		}
	}
}

// MARK: - Updating

extension StringsFile {
	private static let regex = Regex("(?:\\s*/\\*((?:[^*]|(?:\\*+(?:[^*/])))*)\\*+/\\s*)?\\s*(?:^\\s*\"([\\S  ]*)\"\\s*=\\s*\".*?\"\\s*;\\s*$)", options: [.anchorsMatchLines])

	private func loadCommentsIfNeeded() throws {
		guard comments == nil else { return }
		let string: String = try path.read()

		let result: [(String, String)] = StringsFile.regex.allMatches(in: string).map {
			let captures = $0.captures.flatMap { $0 }
			return (captures.last ?? "", captures.first ?? "")
		}

		comments = StringTable(uniqueKeysWithValues: result)
	}

	private func write(content: String) throws {
		guard try path.read(.utf8) != content else { return }

		print("Updating \(path)...")
		try path.write(content)
	}

	public func incrementallyUpdateKeys(with file: StringsFile, placeholder: String?) throws {
		try file.loadContentIfNeeded()
		try file.loadCommentsIfNeeded()
		try loadContentIfNeeded()

		// remove old keys, add new keys & values
		var result = content ?? [:]
		for key in keys.subtracting(file.keys) {
			result.removeValue(forKey: key)
		}
		for key in file.keys.subtracting(keys) {
			result[key] = content?[key] ?? placeholder ?? file.content?[key]
		}

		// generate output
		let output = "\n" + result.sorted {
			$0.key < $1.key
		}.map {
			"""
			/*\(file.comments?[$0.key] ?? "")*/
			"\($0.key)" = "\($0.value)";
			"""
		}.joined(separator: "\n\n").appending("\n")

		try write(content: output)
	}
}
