//
//  FromObjcPropertyModule.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 26/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Foundation

class FromObjcPropertyModule: NSObject {
    
    var properties: [Property] = []
    
    init (properties: String) {
        super.init ()
        generateProperties(properties)
    }
    
    func generateProperties (code: String) {
        let lines = split (code) { $0 == "\n"}
        for line in lines {
            convertLine (line)
        }
    }
    
    func convertLine (line: String) {
        let components = split (line) { $0 == " "}
        let type = cleanType(components[3])
        var name = components[4]
        name = name.stringByReplacingOccurrencesOfString("*", withString: "", options: nil, range: nil)
        name = name.stringByReplacingOccurrencesOfString(";", withString: "", options: nil, range: nil)
        
        properties.append(Property (name: name, type: type, mapName: name))
    }
    
    func cleanType (type: String) -> String {
        if type == "NSString" {
            return "String"
        } else if type == "NSInteger" {
            return "Int"
        } else if type == "CGFloat" {
            return "Float"
        } else if type == "BOOL" {
            return "Bool"
        } else if type.hasPrefix("NSArray") {
            if type.hasSuffix(">") {
                var obj = split (type) { $0 == "<" } [1]
                return obj.stringByReplacingOccurrencesOfString(">", withString: "", options: nil, range: nil)
            } else {
                return "[Any]"
            }
        }
        
        else {
            return type
        }
    }
}
