//
//  SWJsonParser.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

extension String {
    var camelCasedString: String {
        let source = self
        if source.characters.contains(" ") {
            let first = source.substringToIndex(source.startIndex.advancedBy(1))
            let cammel = NSString(format: "%@", (source as NSString).capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
}

final class SWJsonParser {
    private var generatedSWClasses: [SWClass] = []
    private var generatedSWClassPrefix: String?
    private var generatedSWClassName: String = ""
    private var generatedSWClassSuperName: String? = nil

    // MARK: Parser

    func parseJsonToSWClass(name: String, superName: String?, jsonString: String) -> [SWClass] {
        self.generatedSWClasses = []
        self.generatedSWClassName = name
        self.generatedSWClassSuperName = superName
        // detect class prefix between paranthesis
        let start = name.rangeOfString("(")
        let end = name.rangeOfString(")")
        if (end?.startIndex > start?.startIndex) {
            generatedSWClassPrefix = name.substringWithRange(start!.endIndex...end!.startIndex.predecessor())
            generatedSWClassName = generatedSWClassPrefix ?? "" + name.substringFromIndex(end!.endIndex)
        }
        // genereate swift class form json dictionary
        if let dict = jsonStringToDict(jsonString) {
            let sw = generateSWClass(generatedSWClassName, superName: superName, dict: dict)
            generatedSWClasses.append(sw)
        }
        return generatedSWClasses
    }

    // MARK: Helpers

    private func jsonStringToDict (jsonString: String) -> [String: AnyObject]? {
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if let d = data {
            return jsonDataToDict(d)
        } else {
            return nil
        }
    }
    
    private func jsonDataToDict (data: NSData) -> [String: AnyObject]? {
        var jsonError: NSError? = nil
        let dict: AnyObject?
        do {
            dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        } catch let error as NSError {
            jsonError = error
            dict = nil
        }
        if let e = jsonError {
            print("json error " + e.description)
            return nil
        } else {
            if let d = dict as? [String: AnyObject] {
                return d
            } else if let d = dict as? [AnyObject] {
                if let d0 = d[0] as? [String: AnyObject] {
                    return d0
                } else {
                    print("json nil")
                    return nil
                }
            } else {
                print("json nil")
                return nil
            }
        }
    }

    // MARK: Generators
    
    private func generateSWClass(name: String, superName: String?, dict: [String: AnyObject]) -> SWClass {
        let props = generateProperties(dict)
        let sw = SWClass (name: name, superName: superName, properties: props)
        return sw
    }
    
    private func generateProperties(dict: [String: AnyObject]) -> [SWProperty]? {
        var props: [SWProperty] = []
        for (key, value) in dict {
            let cl = getClassFromValue(key, value: value)
            let prop = SWProperty (name: key, type: cl)
            props.append(prop)
        }
        return props.count > 0 ? props : nil
    }
    
    private func getClassFromValue(key: String, value: AnyObject) -> String {
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
            // Custom Array
            if value.count > 0 {
                let serializable = generateSWClass(
                    fixKey(key),
                    superName: generatedSWClassSuperName,
                    dict: value[0] as! [String: AnyObject])
                generatedSWClasses.append(serializable)
            }
            return "[" + fixKey(key) + "]"
        } else {
            // Custom Class
            let serializable = generateSWClass(
                fixKey(key),
                superName: generatedSWClassSuperName,
                dict: value as! [String: AnyObject])
            generatedSWClasses.append(serializable)
            return fixKey(key)
        }
    }
    
    private func fixKey(key: String) -> String {
        var ns = key as NSString
        ns = ns.stringByReplacingOccurrencesOfString("_", withString: " ")
        ns = ns.stringByReplacingOccurrencesOfString(" ", withString: "")
        let fix = (generatedSWClassPrefix ?? "") + (ns as String)
        return fix
    }
}
