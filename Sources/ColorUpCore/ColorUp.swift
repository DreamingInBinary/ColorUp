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
    private let codeGen = CodeGenerator()
    
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
                
                var code:String = codeGen.generateStartOfCodeFileInSwift(with: args)

                colorFolders.forEach { colorFolder in
                    let name = colorFolder.nameExcludingExtension
                    code += codeGen.generateColorCatalogMember(from: name, withOptions: args)
                }
                code += "}"
                
                // Finally generate the file
                try codeGen.writeGeneratedSwiftCodeToDisk(code: code, withOptions: args)
            } catch {
                throw Error.targetProjectDoesntExist
            }
        } catch {
            throw Error.failedToCreateFile
        }
    }
}

// MARK: Code Generation

private struct CodeGenerator {
    // MARK: Public
    func generateStartOfCodeFileInSwift(with args:FileGenOptions) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        return """
        //
        //  \(args.generatedFileName)-\(args.useSwiftUI ? "SwiftUI" : "UIKit").swift
        //
        //  GENERATED CODE: Any edits will be overwritten.
        //  Generated on \(dateFormatter.string(from: Date()))
        //
        
        import \(args.useSwiftUI ? "SwiftUI" : "UIKit")
        
        extension \(args.useSwiftUI ? "Color" : "UIColor") {
        """
    }

    func generateColorCatalogMember(from colorName:String, withOptions args:FileGenOptions) -> String {
        if args.useSwiftUI {
            return generateSwiftUIColor(from: colorName, withOptions: args)
        } else {
            return generateSwiftUIKitColor(from: colorName, withOptions: args)
        }
    }
    
    func writeGeneratedSwiftCodeToDisk(code:String, withOptions args:FileGenOptions) throws {
        let folder:Folder = try Folder.root.subfolder(at: args.targetSaveLocation)
        let appendedFramework = args.useSwiftUI ? "-SwiftUI" : "-UIKit"
        let file:File = try folder.createFile(at: args.generatedFileName + appendedFramework + ".swift")
        try file.write(code.data(using: .utf8)!)
    }

    // MARK: Private
    private func generateSwiftUIKitColor(from colorName:String, withOptions args:FileGenOptions) -> String {
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

    private func generateSwiftUIColor(from colorName:String, withOptions args:FileGenOptions) -> String {
        let signature:String

        if (args.functionPrefix.isEmpty) {
            signature = "static var \(colorName) : Color {"
        } else {
            signature = "static var \(args.functionPrefix)\(colorName) : Color {"
        }
        
        return """
            
            \(signature)
                return Color("\(colorName)")
            }
        
        """
    }
}
