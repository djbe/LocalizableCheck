//
//  Helpers.swift
//  LocalizableCheck
//
//  Created by David Jennes on 20/12/2017.
//

import Foundation
import PathKit

// print an error and exit
func errorOut(_ msg: String) -> Never {
	print("Error: \(msg)")
	exit(EXIT_FAILURE)
}

// print an xcode compatible warning
func warn(file: Path, msg: String) {
	print("\(file):1: warning: \(msg)")
}
