//
//  File.swift
//  
//
//  Created by Jordan Morgan on 1/24/20.
//

import Foundation
import Files

public extension ColorUp {
    enum Error: Swift.Error {
        case noArguments
        case missingFileName
        case failedToCreateFile
    }
}

public final class ColorUp {
    private let commandLine = CommandLineUtil()
    
    public init() {}
    
    // MARK: Public API
    
    public func execute() throws {
        let args = commandLine.evaluateCommandLine()
        
        guard !commandLine.arguments.isEmpty else {
            throw Error.noArguments
        }
        
        guard args.targetDirectory != "" else {
            throw Error.missingFileName
        }
        
        do {
            let file:File = try Folder.current.createFile(at: args.targetDirectory + ".swift")
            
            let generatedCode = """
            func aMethod() -> Void {
                print()
            }
            """.data(using: .utf8)
            
            try file.write(generatedCode!)
        } catch {
            throw Error.failedToCreateFile
        }
    }
}
