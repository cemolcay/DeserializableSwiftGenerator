//
//  ObjectMapperGenerator.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

class ObjectMapperGenerator: SWGenerator {

    // MARK: SWGeneratorProtocol
    
    override var deserialzeProtocolName: String? {
        get {
            return "MapperProtocol"
        }
    }
    
    override func generateClassBody(sw: SWClass) -> String {
        var body = generateInit ()
        body += "\n\n"
        body += generateMap(sw)
        
        return body
    }
    
    
    
    // MARK: ObjectMapper Generator
    
    func generateInit () -> String {
        var initMethod = "\n\t// MARK: Mapper Protocol\n\n"
        initMethod += "\trequired init () {"
        initMethod += "\n\n\t}"
        
        return initMethod
    }
    
    func generateMap (sw: SWClass) -> String {
        var map = ""
        
        if let s = sw.superName {
            map = "\toverride func map(mapper: Mapper) {\n"
        } else {
            map = "\tfunc map(mapper: Mapper) {\n"
        }
        
        if let p = sw.properties {
            for prop in p {
                map += "\t\t" +
                        prop.name +
                        " <= " +
                        "mapper[\"" +
                        prop.name +
                        "\"]\n"
            }
        }
        
        map += "\t}\n"
        
        return map
    }
}
