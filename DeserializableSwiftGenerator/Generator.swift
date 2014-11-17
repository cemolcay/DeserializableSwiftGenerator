//
//  Generator.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import Foundation

class Generator: NSObject {

    private func generateClass (name: String, superClassName: String, jsonString: String) -> ClassObject {
        var classObject = ClassObject ()
        
        classObject.name = name
        classObject.superClassName = superClassName
        
        let deserializer = JsonDeserializerModule (json: jsonString)
        classObject.properties = deserializer.getProperties()

        return classObject
    }
    
    private func generateClass (name: String, superClassName: String, properties:[Property]) -> ClassObject {
        var classObject = ClassObject ()
        classObject.name = name
        classObject.superClassName = superClassName
        classObject.properties = properties
        return classObject
    }
    
    
    
    func generate (name: String, superClassName: String, jsonString: String) {
        generateClass(name, superClassName: superClassName, jsonString: jsonString).save()
    }
    
    func generate (name: String, superClassName: String, properties:[Property]) {
        generateClass(name, superClassName: superClassName, properties: properties).save()
    }
    
    func generate (classObject: ClassObject) {
        classObject.save()
    }
}
