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
        return String(Array(self.characters)[i])
    }
}

final class JSONHelperGenerator: SWGenerator {
    
    // MARK: SWGeneratorProtocol
    
    override var deserialzeProtocolName: String? {
        return "Deserializable"
    }
    
    override func generateClassBody(sw: SWClass) -> String {
        var body = "\trequired init(data: [String : AnyObject]) {\n"
        if sw.superName != nil {
            body += "\t\tsuper.init(data: data)\n"
        } else {
            body += "\n"
        }
        if let p = sw.properties {
            for prop in p {
                body += "\t\t" +
                        fixName(prop.name) +
                        " <-- " +
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
}
