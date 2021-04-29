//
//  File.swift
//  
//
//  Created by Jordan Morgan on 1/24/20.
//

import Foundation
import TSCUtility

public struct CommandLineUtil {
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    private let parser = ArgumentParser(usage: "<options>", overview: "Creates a generated extension for UIKit's UIColor or SwiftUI's Color based on the colors in your project's asset catalog.")
    
    // MARK: Command Line Args
    
    /// The desired name of the resulting code file. Defaults to "ColorCatalogExtensions".
    private let fileName: OptionArgument<String>
    /// The location of the Xcode project to parse. Required.
    private let targetProjectDirectory: OptionArgument<String>
    /// The location where to save the generated file. Required.
    private let targetSaveLocation: OptionArgument<String>
    /// The language preference. Defaults to Swift.
    private let useForceUnwrapping: OptionArgument<Bool>
    /// An optional prefix to apply to each function call.
    private let functionPrefix: OptionArgument<String>
    /// A boolean indicating whether to generate SwiftUI or UIKit color extensions.
    private let frameworkChoice: OptionArgument<Bool>

    init() {
        fileName = parser.add(option: "--fileName", shortName: "-f", kind: String.self, usage: "The name of the generated file. Defaults to \"ColorCatalogExtensions\".")
        targetProjectDirectory = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "Required: The location of the project's .xcasset folder that contains the colors to use for code generation.")
        targetSaveLocation = parser.add(option: "--saveLocation", shortName: "-s", kind: String.self, usage: "Required: A fully formed location on disk to save the generated code.")
        useForceUnwrapping = parser.add(option: "--forceUnwrap", shortName: "", kind: Bool.self, usage: "If passed, the code will force unwrap the color in its implementation.")
        functionPrefix = parser.add(option: "--prefix", shortName: "-fp", kind: String.self, usage: "An optional prefix to apply to each function's header.")
        frameworkChoice = parser.add(option: "--SwiftUI", shortName: "-sw", kind: Bool.self, usage: "If set to true, SwiftUI extensions will be generated. Otherwise, UIKit extensions are created by default.")
    }
    
    // MARK: Public API
    
    public func evaluateCommandLine() -> FileGenOptions {
        do {
            let parsedArguments = try parser.parse(arguments)
            let projectDirectory = parsedArguments.get(targetProjectDirectory) ?? ""
            let saveLocation = parsedArguments.get(targetSaveLocation) ?? ""
            let prefersForceUnwrap = parsedArguments.get(useForceUnwrapping) ?? false
            let prefix = parsedArguments.get(functionPrefix) ?? ""
            let wantsSwiftUIExtensions = parsedArguments.get(frameworkChoice) ?? false
            
            return FileGenOptions(targetDirectory: projectDirectory,
                                  targetSaveLocation: saveLocation,
                                  useForceUnwrap: prefersForceUnwrap,
                                  functionPrefix: prefix,
                                  useSwiftUI: wantsSwiftUIExtensions)
        }
        catch let error as ArgumentParserError {
            print(error.description)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return FileGenOptions(targetDirectory: "")
    }
    
    public func debugValues() -> FileGenOptions {
        let projectDirectory = "/Users/jordanmorgan/Documents/Buffer/buffer-ios/App/Buffer/Colors.xcassets"
        let saveLocation = "/Users/jordanmorgan/Documents/Buffer/buffer-ios/App/Buffer/Swift Extensions/"
        let prefersForceUnwrap = false
        let prefix = "bfr_"
        
        return FileGenOptions(targetDirectory: projectDirectory,
                              targetSaveLocation: saveLocation,
                              useForceUnwrap: prefersForceUnwrap,
                              functionPrefix: prefix,
                              useSwiftUI: false)
    }
}

public struct FileGenOptions {
    var generatedFileName:String = "ColorCatalogExtensions"
    var targetDirectory:String = ""
    var targetSaveLocation:String = ""
    var useForceUnwrap:Bool = false
    var functionPrefix:String = ""
    var useSwiftUI:Bool = false
}

