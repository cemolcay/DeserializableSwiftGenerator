//
//  SWGenerator.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

protocol SWGeneratorProtocol {
    var deserialzeProtocolName: String? {get}
    func generateClassBody (sw: SWClass) -> String
}

class SWGenerator: SWGeneratorProtocol {

    // MARK: Init
    
    init () {
        
    }
    
    
    // MARK: SWGeneratorProtocol
    
    var deserialzeProtocolName: String? {
        get {
            return nil
        }
    }
    
    func generateClassBody(sw: SWClass) -> String {
        return ""
    }
    
    
    
    // MARK: Generator
    
    func generateSwiftFile (sw: SWClass) -> String {
        var gen = sw.getHeader(deserialzeProtocolName)
        gen += sw.getFields() + "\n"
        gen += generateClassBody(sw)
        gen += "\n}"
        
        return gen
    }
    
    func saveToDesktop (sw: SWClass) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .AllDomainsMask, true)
        let desktop = paths[0] as String
        let path = desktop + "/" + sw.name + ".swift"
        
        let file = generateSwiftFile(sw)
        return file.writeToFile(path,
            atomically: false,
            encoding: NSUTF8StringEncoding,
            error: nil)
    }
}
