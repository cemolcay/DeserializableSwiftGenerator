//
//  ClassObject.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import Foundation

class ClassObject: NSObject {
    
    // MARK: Properties
    
    var name: String? //className was taken by swift
    var superClassName : String?
    var properties: [Property]?
    
    
    
    // MARK: Makers
    
    private func makeHeader () -> String {
        return "import UIKit" + newline() + "class " + name! + ": " + superClassName! + ", Deserializable {" + newline()
    }
    
    private func makeProperties () -> String {
        var field = ""
        for prop in properties! {
            field += newline() + tab(1) + prop.makeVariable()
        }
        return field
    }
    
    private func makeMapper () -> String {
        var method = tab(1) + "required init (data: [String: AnyObject]) {" + newline() + tab(2) + "super.init (data: data)"
        
        for prop in properties! {
            method += newline() + tab(2) + prop.makeMap()
        }
        
        method += newline() + tab(1) + "}"
        return method
    }
    
    private func makeClass () -> String {
        return makeHeader() + newline() + makeProperties() + newline() + newline() + makeMapper() + newline() + "}"
    }
    
    
    
    // MARK: Generator
    
    func make () -> String {
        if valid() {
            return makeClass()
        } else {
            return "not valid"
        }
    }
    
    func valid () -> Bool {
        if let name = self.name {
            if let superclass = superClassName {
                return true
            }
        }
        
        return false
    }
    
    func save () {
        var result = make().writeToFile("/Users/cem/Desktop/" + name! + ".swift", atomically: false, encoding: NSUTF8StringEncoding, error: nil)
        println("\(result)")
    }

    

    // MARK: Utils
    
    func newline () -> String {
        return "\n"
    }
    
    func tab (count: Int) -> String {
        var t = ""
        for _ in 0..<count {
            t += "\t"
        }
        return t
    }
}
