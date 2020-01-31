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
        case missingTargetProjectName
        case targetProjectDoesntExist
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
            throw Error.missingTargetProjectName
        }
        
        do {
            // Test: /Users/jordan/Documents/Projects/ColorUp/TestCatalog.xcassets/Color.colorset
            // Get into the project
            do {
                let assetFolder = try Folder.current.subfolder(at: "TestCatalog.xcassets/")
                let colorFolders = assetFolder.subfolders.filter { $0.name.contains(".colorset") }
                
                var testString = ""
                try colorFolders.forEach { colorFolder in
                    let colorFile = try colorFolder.file(at: "Contents.json")
                    let colorData = try colorFile.read()
                    testString += String(data: colorData, encoding: .utf8) ?? "OH"
                }
                
                // Finally generate the file
                let file:File = try Folder.current.createFile(at: args.targetDirectory + ".swift")
                
//                let generatedCode = """
//                func aMethod() -> Void {
//                    print()
//                }
//                """.data(using: .utf8)
                
                try file.write(testString.data(using: .utf8)!)
            } catch {
                throw Error.targetProjectDoesntExist
            }
        } catch {
            throw Error.failedToCreateFile
        }
    }
}
