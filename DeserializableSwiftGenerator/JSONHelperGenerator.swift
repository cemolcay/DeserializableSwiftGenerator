//
//  JSONHelperGenerator.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

class JSONHelperGenerator: SWGenerator {
    
    // MARK: SWGeneratorProtocol
    
    override var deserialzeProtocolName: String? {
        get {
            return "Deserializable"
        }
    }
    
    override func generateClassBody(sw: SWClass) -> String {
        var body = "\trequired init(data: [String : AnyObject]) {\n"
        
        if let s = sw.superName {
            body += "\t\tsuper.init(data: data)\n\n"
        } else {
            body += "\n"
        }
        
        if let p = sw.properties {
            for prop in p {
                body += "\t\t" +
                        fixName(prop.name) +
                        " " +
                        operatorForPropertyType(prop.type) +
                        " data[\"" +
                        prop.name +
                        "\"]\n"
            }
        }
        
        body += "\t}\n"
        return body
    }
    
    func fixName (name: String) -> String {
        if name == "data" {
            return "self.data"
        }
        
        return name
    }
    
    func operatorForPropertyType (type: String) -> String {
        var op = ""
        
        if type[0] == "[" {
            let t = type[advance(type.startIndex, 1)..<advance(type.endIndex, -1)]
            let allowed = ["String", "Float", "Int", "Double", "Bool"]
            
            if contains(allowed, t) {
                op = "<<<*"
            } else {
                op = "<<<<*"
            }
        } else {
            let allowed = ["String", "Float", "Int", "Double", "Bool"]
            
            if contains(allowed, type) {
                op = "<<<"
            } else {
                op = "<<<<"
            }
        }
        
        return op
    }
    
    
    
    // MARK: JSONHelper Generator
    
    func generateMap (sw: SWClass) -> String {
        var map = ""
        
        if let s = sw.superName {
            map = "\toverride func map(mapper: Mapper) {\n"
        } else {
            map = "\tfunc map(mapper: Mapper) {\n"
        }
        
        if let p = sw.properties {
            for prop in p {
                map += "\t\t" + prop.name + " <= " + "mapper[\"" + prop.name + "\"]\n"
            }
        }
        
        return map + "\n"
    }

}
