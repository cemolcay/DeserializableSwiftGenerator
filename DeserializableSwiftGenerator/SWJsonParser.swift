//
//  SWJsonParser.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

class SWJsonParser {
    
    init () {
        
    }
    
    func generateSWClass (name: String, superName: String?, json: String) -> SWClass {
        let props = generateProperties(json)
        let swclass = SWClass (name: name, superName: superName, properties: props)

        return swclass
    }
    
    func generateProperties (jsonString: String) -> [SWProperty]? {
        var jsonError: NSError? = nil
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
        
        if let d = dict as? [String: AnyObject] {
            var props: [SWProperty] = []
            
            for (key, value) in d {
                let cl = getClassFromValue(value)
                let prop = SWProperty (name: key, type: cl)
                
                props.append(prop)
            }
            
            return props.count > 0 ? props : nil
        }
        
        return nil
    }
    
    func getClassFromValue (value: AnyObject) -> String {

        if value is String {
            return "String"
        } else if value is Int {
            return "Int"
        } else if value is Float {
            return "Float"
        } else if value is Double {
            return "Double"
        } else if value is [String] {
            return "[String]"
        } else if value is [Int] {
            return "[Int]"
        } else if value is [Float] {
            return "[Float]"
        } else if value is [Double] {
            return "[Double]"
        } else if value is [AnyObject] {
            return "[Serializable]"
        } else if value is NSNull {
            return "String"
        } else {
            return "Serializable"
        }
    }

}
