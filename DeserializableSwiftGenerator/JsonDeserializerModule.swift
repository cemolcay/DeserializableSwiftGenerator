//
//  JsonDeserializerModule.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import Foundation

class JsonDeserializerModule: NSObject {

    var jsonObject: Dictionary<String, AnyObject>?
    
    init (json: String) {
        super.init()
        
        var jsonError : NSError?
        var jsonData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &jsonError) as? Dictionary

        if let error = jsonError {
            println("json error " + error.description)
        }
        
        //println("data \(jsonData)\nobject \(jsonObject) \nstring \(json)")
    }
    
    
    func getProperties () -> [Property] {
        var result : [Property] = []
        
        if let dict = jsonObject {
            for (key, value) in jsonObject! {
                let clean = cleanClass(value)
                var prop = Property (name: key, type: clean, mapName: key)
                
                if clean == "Array" {
                    if value.count > 0 {
                        if let first = value.firstObject as? [String: AnyObject] {
                            if let type: String = first["__type"] as? String {
                                println("type, " + type)
                                prop.__type = "[" + type.componentsSeparatedByString(":").first! + "]"
                            }
                        }
                    }
                }
                
                result.append(prop)
            }
        }
        
        return result
    }

    func cleanClass (object: AnyObject) -> String {
        let name = "\(_stdlib_getTypeName(object))"

        if (name == "__NSCFString" || name == "NSTaggedPointerString" || name == "__NSCFConstantString") {
            return "String"
        } else if (name == "__NSCFNumber") {
            return "Float"
        } else if (name == "__NSArrayI") {
            return "Array"
        } else if (name == "__NSCFDictionary") {
            return "Dictionary"
        } else {
            return name
        }
    }
}
