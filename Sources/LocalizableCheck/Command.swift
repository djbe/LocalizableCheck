//
//  Command.swift
//  LocalizableCheck
//
//  Created by David Jennes on 21/12/2017.
//

import Foundation

enum Command {
	typealias CommandLineResult = (output: String, errors: [String], exitCode: Int32)

	static func run(command: String, arguments: [String]?) -> CommandLineResult {
		let task = Process()
		task.launchPath = command
		task.arguments = arguments

		let outpipe = Pipe()
		task.standardOutput = outpipe
		let errpipe = Pipe()
		task.standardError = errpipe

		task.launch()

		var errors: [String] = []
		let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
		if var string = String(data: errdata, encoding: .utf8) {
			string = string.trimmingCharacters(in: .newlines)
			errors = string.components(separatedBy: "\n")
		}

		let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: outdata, encoding: .utf8) ?? ""

		task.waitUntilExit()
		let status = task.terminationStatus

		return (output, errors, status)
	}
}
