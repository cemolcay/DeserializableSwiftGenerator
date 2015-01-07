//
//  SWJsonParser.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

class SWJsonParser {
    
    
    // MARK: Properties
    
    private var generatedSWClasses: [SWClass] = []
    private var generatedSWClassPrefix: String = ""
    private var generatedSWClassName: String = ""
    private var generatedSWClassSuperName: String? = nil
    
    
    
    // MARK: Lifecycle
    
    init () {
        
    }

    func jsonStringToDict (jsonString: String) -> [String: AnyObject]? {
        println(jsonString)
        var jsonError: NSError? = nil
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)

        if let e = jsonError {
            println("json error " + e.description)
            return nil
        } else {
            if let d = dict as? [String: AnyObject] {
                return d
            } else {
                println("json nil")
                return nil
            }
        }
    }
    
    func parseJsonToSWClass (name: String, superName: String?, jsonString: String) -> [SWClass] {
        self.generatedSWClasses = []
        self.generatedSWClassName = name
        self.generatedSWClassSuperName = superName
        
        let start = name.rangeOfString("(")
        let end = name.rangeOfString(")")
        if (end?.startIndex > start?.startIndex) {
            generatedSWClassPrefix = name.substringWithRange(start!.endIndex...end!.startIndex.predecessor())
            generatedSWClassName = generatedSWClassPrefix + name.substringFromIndex(end!.endIndex)
        }
        
        if let dict = jsonStringToDict(jsonString) {
            let sw = generateSWClass(generatedSWClassName, superName: superName, dict: dict)
            generatedSWClasses.append(sw)
        }
        
        return generatedSWClasses
    }
    
    
    
    // MARK: Generator
    
    func generateSWClass (name: String, superName: String?, dict: [String: AnyObject]) -> SWClass {
        let props = generateProperties(dict)
        let sw = SWClass (name: name, superName: superName, properties: props)

        return sw
    }
    
    func generateProperties (dict: [String: AnyObject]) -> [SWProperty]? {
        var props: [SWProperty] = []
        
        for (key, value) in dict {
            let cl = getClassFromValue(key, value: value)
            let prop = SWProperty (name: key, type: cl)
            
            props.append(prop)
        }
        
        return props.count > 0 ? props : nil
    }
    
    func getClassFromValue (key: String, value: AnyObject) -> String {
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
        } else if value is NSNull {
            return "String"
        } else if value is [AnyObject] {
            if value.count > 0 {
                let serializable = generateSWClass(generatedSWClassPrefix + key, superName: generatedSWClassSuperName, dict: value[0] as [String: AnyObject])
                generatedSWClasses.append(serializable)
            }
            
            return String (format: "[%@]", generatedSWClassPrefix + key)
        } else {
            let serializable = generateSWClass(generatedSWClassPrefix + key, superName: generatedSWClassSuperName, dict: value as [String: AnyObject])
            generatedSWClasses.append(serializable)
            
            return key
        }
    }

}
