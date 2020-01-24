//
//  File.swift
//  
//
//  Created by Jordan Morgan on 1/24/20.
//

import Foundation
import TSCUtility

public struct CommandLineUtil {
    // The first argument is always the executable, drop it
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    
    private let parser = ArgumentParser(usage: "<options>", overview: "Creates a generated extension for UIColor based on the colors in your project's asset catalog.")
    
    // Command line variables and options
    private let fileName: OptionArgument<String>
    //let uppercased: OptionArgument<Bool> = parser.add(option: "--uppercased", kind: Bool.self)
    
    init() {
        fileName = parser.add(option: "--fileName", shortName: "-f", kind: String.self, usage: "The name of the generated file")
        
    }
    
    // MARK: Public API
    public func evaluateCommandLine() -> FileGenOptions {
        do {
            let parsedArguments = try parser.parse(arguments)
            
            if let name = parsedArguments.get(fileName) {
                return FileGenOptions(targetDirectory: name)
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

