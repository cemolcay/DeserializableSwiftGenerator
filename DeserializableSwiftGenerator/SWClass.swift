//
//  SWClass.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//


final class SWClass {
    var name: String
    var superName: String?
    var properties: [SWProperty]?
    
    init (name: String, superName: String?, properties: [SWProperty]?) {
        self.name = name
        self.superName = superName
        self.properties = properties
    }
    
    func getHeader (protocolName: String?) -> String {
        var header = "class " + name
        if let s = superName {
            header += ": " + s
            if let p = protocolName {
                header += ", " + p
            }
        } else {
            if let p = protocolName {
                header += ": " + p
            }
        }
        return header + " {\n"
    }
    
    func getFields () -> String {
        var fields = ""
        if let p = properties {
            for prop in p {
                fields += "\t" + prop.getVariableLine() + "\n"
            }
        }
        return fields
    }
}
