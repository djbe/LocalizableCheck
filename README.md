# LocalizableCheck

[![Version](https://img.shields.io/cocoapods/v/LocalizableCheck.svg?style=flat)](https://cocoapods.org/pods/LocalizableCheck)
[![License](https://img.shields.io/cocoapods/l/LocalizableCheck.svg?style=flat)](https://cocoapods.org/pods/LocalizableCheck)
[![Platform](https://img.shields.io/cocoapods/p/LocalizableCheck.svg?style=flat)](https://cocoapods.org/pods/LocalizableCheck)
[![Swift version](https://img.shields.io/badge/Swift-4-orange.svg)](https://cocoapods.org/pods/LocalizableCheck)


## Requirements

_None_

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate LocalizableCheck into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'LocalizableCheck'
```

Then, run the following command:

```bash
$ pod install
```


## Usage

Simply invoke the tool by providing the path to your `Resources` folder as follows.

```bash
LocalizableCheck "Application/Resources"
```

The tool will:
- Check if your `Localizable.strings` files are in sync (missing and extraneous keys) across language bundles, using the **english** translation as a source.
- Update the base internationalisation strings files for `storyboard`s and `xib`s.

By default, for base internationalisation strings, the tool will copy the value of new strings from the storyboard to all language bundles. If you prefer, you can replace these with a custom placeholder as follows:

```bash
LocalizableCheck --placeholder "UNTRANSLATED" "Application/Resources"
```

## Creating a release

Just run the following command:

```bash
xcrun swift build -c release --static-swift-stdlib
```

The built binary will be at `./.build/x86_64-apple-macosx10.10/release/LocalizableCheck`.

## Author

David Jennes


## License

LocalizableCheck is available under the MIT license. See the LICENSE file for more info.
