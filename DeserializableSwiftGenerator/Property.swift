//
//  Property.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

class Property: NSObject {

    var propertyName : String?
    var propertyType : String?
    var propertyMapName : String?
    
    var __type: String = "Array"
    
    init (name: String, type: String, mapName: String) {
        super.init()
        
        propertyName = name
        propertyType = type
        propertyMapName = mapName
    }
    
    

    func valid () -> Bool {
        
        if (propertyName!.isEmpty) {
            return false
        } else {
            if (propertyType!.isEmpty) {
                propertyType = "AnyObject"
            }
            return true
        }
    }
    
    func makeVariable () -> String {
        if valid() {
            if propertyType == "Array" {
                return "var " + propertyName! + ": " + __type + "?"
            } else {
                return "var " + propertyName! + ": " + propertyType! + "?"
            }
        } else {
            return ""
        }
    }
    
    func makeMap () -> String {
        if valid() {
            if propertyType == "Array" {
                return propertyName! + " <<<<* " + "data[\"" + propertyMapName! + "\"]"
            } else {
                return propertyName! + " <<< " + "data[\"" + propertyMapName! + "\"]"
            }
        } else {
            return ""
        }
    }
}
