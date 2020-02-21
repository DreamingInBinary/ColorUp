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
        case missingSaveLocation
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
        
        guard args.targetSaveLocation != "" else {
            throw Error.missingTargetProjectName
        }
        
        do {
            // Get into the project
            do {
                let assetFolder = try Folder.root.subfolder(named: args.targetDirectory)
                let colorFolders = assetFolder.subfolders.filter { $0.name.contains(".colorset") }
                
                var code = generateCodeStartInSwift(with: args.generatedFileName)
                
                colorFolders.forEach { colorFolder in
                    let name = colorFolder.nameExcludingExtension
                    code += generateSwiftColor(from: name, withOptions: args)
                }
                code += "}"
                
                // Finally generate the file
                try writeGeneratedSwiftCodeToDisk(code: code, withOptions: args)
            } catch {
                throw Error.targetProjectDoesntExist
            }
        } catch {
            throw Error.failedToCreateFile
        }
    }
}

// MARK: Code Generation

fileprivate func generateCodeStartInSwift(with fileName:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy"
    
    return """
    //
    //  \(fileName).swift
    //  Crossover
    //
    //  GENERATED CODE: Any edits will be overwritten.
    //  Generated on \(dateFormatter.string(from: Date()))
    //
    
    import UIKit
    
    extension UIColor {
    """
}

fileprivate func generateSwiftColor(from colorName:String, withOptions args:FileGenOptions) -> String {
    let signature:String
    let forceUnwrapModifidier = args.useForceUnwrap ? "" : "?"
    
    if (args.functionPrefix.isEmpty) {
        signature = "class var \(colorName) : UIColor\(forceUnwrapModifidier) {"
    } else {
        signature = "class var \(args.functionPrefix)\(colorName) : UIColor\(forceUnwrapModifidier) {"
    }
    
    return """
        
        \(signature)
            return UIColor(named: "\(colorName)")\(args.useForceUnwrap ? "!" : "")
        }
    
    """
}

fileprivate func writeGeneratedSwiftCodeToDisk(code:String, withOptions args:FileGenOptions) throws {
    let folder:Folder = try Folder.root.subfolder(at: args.targetSaveLocation)
    let file:File = try folder.createFile(at: args.generatedFileName + ".swift")
    try file.write(code.data(using: .utf8)!)
}
