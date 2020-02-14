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
    private let parser = ArgumentParser(usage: "<options>", overview: "Creates a generated extension for UIColor based on the colors in your project's asset catalog.")
    
    // MARK: Command Line Args
    
    /// The desired name of the resulting code file. Defaults to "ColorCatalogExtensions".
    private let fileName: OptionArgument<String>
    /// The location of the Xcode project to parse. Required.
    private let targetProjectDirectory: OptionArgument<String>
    /// The language preference. Defaults to Swift.
    private let languageObjc: OptionArgument<Bool>

    init() {
        fileName = parser.add(option: "--fileName", shortName: "-f", kind: String.self, usage: "The name of the generated file. Defaults to \"ColorCatalogExtensions\".")
        targetProjectDirectory = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The location of the project's .xcasset folder that contains the colors to use for code generation.")
        languageObjc = parser.add(option: "--useObjC", shortName: "-objc", kind: Bool.self, usage: "If passed, the code will be generated in Objective-C.")
    }
    
    // MARK: Public API
    
    public func evaluateCommandLine() -> FileGenOptions {
        do {
            let parsedArguments = try parser.parse(arguments)
            let projectDirectory = parsedArguments.get(targetProjectDirectory) ?? ""
            let wantsObjC = parsedArguments.get(languageObjc) ?? false
            
            return FileGenOptions(targetDirectory: projectDirectory, useObjC: wantsObjC)
        }
        catch let error as ArgumentParserError {
            print(error.description)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return FileGenOptions(targetDirectory: "")
    }
}

public struct FileGenOptions {
    var generatedFileName:String = "ColorCatalogExtensions"
    var targetDirectory:String = ""
    var useObjC:Bool = false
}

