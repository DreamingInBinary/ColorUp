<p align="center">
  <img src="/hero.png?raw=true" alt="Header Image" />
</p>

### Motivations
At [Buffer](https://www.buffer.com) we use color catalogs extensively across our own iOS apps. But, we find that we often can mistype the names (resulting in a nil color instance) and that we have quite a few of them. This is the main problem we set out to solve. Using a generator such as this gives us the flexibility of color catalogs with the advantages of concrete function calls:

```swift
// Before 😅

// UIKit. If you mess this up or force unwrap, you could crash.
let aColor = UIColor(named: "iHopeITypedThisRight") 

// SwiftUI. If you mess this one up, you'll get primary text by default.
Text(stepToDo.backingModel.stepAbstract ?? "")
                .lineLimit(nil)
                .foregroundColor(Color("gettingStartedTextSubhead"))

// After. Strongly typed colors, no chance of typos. 😊

// UIKit
let aColor = UIColor.namedColor

// SwiftUI
Text(stepToDo.backingModel.stepAbstract ?? "")
                .lineLimit(nil)
                .foregroundColor(.gettingStartedTextSubhead)
```

There are other things in the pipeline for the future, such as supporting Objective-C and bundle asset catalog lookups, but this is our start!

### Usage
To install ColorUp, download this repository locally to your machine.

Then navigate to its location:
```bash
$ cd location/to/colorup
```
From there, you must provide two things at a minimum:

1. The fully formed file location of the asset catalog with the colors, `-p`.
2. The fully formed file location of where you'd like to save the generated file, `-s`.

To get a feel for what you can use, run the `--help` command:
```bash
$ swift run ColorUp --help
```
Here is what a command would look like:
```bash
$ swift run ColorUp -p "users/jordan/documents/anApp/assets.xcassets/" -s "users/jordan/documents/anApp/extensions/"
```

If the asset catalog has one color named "MyColor", the result would look like this for UIKit:
```swift
//
//  ColorCatalogExtensions-UIKit.swift
//
//  GENERATED CODE: Any edits will be overwritten.
//  Generated on Feb 21 2020
//

import UIKit

extension UIColor {    
    class var MyColor : UIColor? {
        return UIColor(named: "MyColor")
    }
}
```

...and for SwiftUI:
```swift
//
//  ColorCatalogExtensions-SwiftUI.swift
//
//  GENERATED CODE: Any edits will be overwritten.
//  Generated on Feb 21 2020
//

import SwiftUI

extension Color {    
    static var MyColor : Color {
        return Color("MyColor")
    }
}
```

If you'd like to run ColorUp from anywhere and not have to nagivate to its location on the file system, you build it for release and move it to the executable binaries folder:
```bash
$ swift build -c release
$ cp .build/release/ColorUp /usr/local/bin/ColorUp
```

This allows you to just open Terminal and run it from anywhere.
### Options

**Xcode Project: <span style="color: red;">Required</span>**
```bash
--project "path/to/project"
```
The complete path to the asset catalog that contains the colors you wish to generate an extension file for.

**Save Location:<span style="color: red;"> Required</span>**
```bash
--saveLocation "path/to/save/extension"
```
The complete path where you wish to save the file at.

**Use force unwrapping: Optional**
```bash
--forceUnwrap
```
Use this option to generate a force-unwrapped color call. Note that SwiftUI code will ignore this option, as it's `Color(name)` initializer doesn't produce an optional type.
Example:
```swift
class var MyColor : UIColor {
  return UIColor(named: "MyColor")!
}
```
versus the default:
```swift
class var MyColor : UIColor? {
  return UIColor(named: "MyColor")
}
```

**Function Prefix: Optional**
```bash
-fp "aPrefix"
```
Puts the supplied string in front of the generated functions. 
Example:
```swift
// UIKit
class var aPrefixMyColor : UIColor {
  return UIColor(named: "MyColor")!
}

// SwiftUI
static var aPrefixMyColor: Color {
  return Color("MyColor")
}
```
versus the default:
```swift
// UIKit
class var MyColor : UIColor? {
  return UIColor(named: "MyColor")
}

// SwiftUI
static var MyColor: Color {
  return Color("MyColor")
}
```

**File Name: Optional**
```bash
--fileName "GeneratedColors"
```
The name of the generated file containing the extensions. Defaults to `ColorCatalogExtensions-UIKit.swift` for UIKit, and `ColorCatalogExtensions-SwiftUI.swift` for SwiftUI. 

**Generate SwiftUI Code: Optional**
```bash
--SwiftUI 
```
A `boolean`, if present the generated code is for SwiftUI's `Color` type. If not, it'll default to UIKit and `UIColor`.

### Contributing
ColorUp welcomes anyone to contribute. Here's a quick start guide:

### 1. Clone the project
```bash
$ git clone https://github.com/DreamingInBinary/ColorUp.git
```

### 2. Generate an Xcode Project
```bash
$ cd path/to/colorup
$ swift package generate-xcodeproj
```

### 3. Build the Project
```bash
$ swift build 
```

### 4. Run It
```bash
$ swift run ColorUp --saveLocation "path/to/save/extension" --project "path/to/project"
```

I find it's much easier to run it locally from an Xcode project and use the `CommandLineUtil` class to provide debug values using `debugValues()`.

For development, all the files you'll need to use are within `ColorUpCore`:
1. `ColorUp.swift` runs the actual program, and has the code to generate the file.
2. `CommandLineUtil.swift` houses logic to get input from the command the user has run, and houses them within `FileGenOptions`.

<hr />

Any questions? Feel free to reach out to on [Twitter](https://www.twitter.com/jordanmorgan10) or open an issue!
