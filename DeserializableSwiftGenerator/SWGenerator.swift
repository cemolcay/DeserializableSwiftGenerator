//
//  SWGenerator.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

protocol SWGeneratorProtocol {
    var deserialzeProtocolName: String? { get }
    func generateClassBody (sw: SWClass) -> String
}

class SWGenerator: SWGeneratorProtocol {
    var deserialzeProtocolName: String? {
        return nil
    }
    
    func generateClassBody(sw: SWClass) -> String {
        return ""
    }

    func generateSwiftFile (sw: SWClass) -> String {
        var gen = sw.getHeader(deserialzeProtocolName)
        gen += sw.getFields() + "\n"
        gen += generateClassBody(sw)
        gen += "}"
        return gen
    }
    
    func saveToDesktop (sw: SWClass) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .AllDomainsMask, true)
        let desktop = paths[0] 
        let path = desktop + "/" + sw.name + ".swift"
        let file = generateSwiftFile(sw)
        do {
            try file.writeToFile(path,
                        atomically: false,
                        encoding: NSUTF8StringEncoding)
            return true
        } catch _ {
            return false
        }
    }
}
