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
    
    /// The location of the Xcode project to parse. Required.
    private let targetProjectDirectory: OptionArgument<String>
    
    //private let fileName: OptionArgument<String>
    //let uppercased: OptionArgument<Bool> = parser.add(option: "--uppercased", kind: Bool.self)
    
    init() {
//        fileName = parser.add(option: "--fileName", shortName: "-f", kind: String.self, usage: "The name of the generated file")
        targetProjectDirectory = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The location of the project that contains the Asset Catalog to use for code generation.")
        
    }
    
    // MARK: Public API
    public func evaluateCommandLine() -> FileGenOptions {
        do {
            let parsedArguments = try parser.parse(arguments)
            
            if let project = parsedArguments.get(targetProjectDirectory) {
                return FileGenOptions(targetDirectory: project)
            } else {
                return FileGenOptions(targetDirectory: "")
            }
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
    // A struct that represents the options the user passed in
    var targetDirectory:String = ""
}

