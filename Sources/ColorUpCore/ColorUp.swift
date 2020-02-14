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
                
                var code = generateCodeStartInSwift()
                
                colorFolders.forEach { colorFolder in
                    let name = colorFolder.nameExcludingExtension
                    code += generateSwiftColor(from: name)
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

fileprivate func generateCodeStartInSwift() -> String {
    return """
    import Foundation
    import UIKit
    
    extension UIColor : CodedColors {
    """
}

fileprivate func generateSwiftColor(from colorName:String) -> String {
    return """
        
        class func cu_\(colorName)() -> UIColor {
            return UIColor(named: "\(colorName)")
        }
    
    """
}

fileprivate func writeGeneratedSwiftCodeToDisk(code:String, withOptions args:FileGenOptions) throws {
    let file:File = try Folder.current.createFile(at: args.generatedFileName + ".swift")
    try file.write(code.data(using: .utf8)!)
}

fileprivate func generateCodeStartInObjC() -> String {
    return """
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    
    @interface UIColor (CodedColors)
    """
}

fileprivate func generateObjCColor(from colorName:String) -> String {
    return ""
}
