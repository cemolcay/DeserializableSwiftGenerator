//
//  SWProperty.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

final class SWProperty {
    var name: String
    var type: String
    
    init (name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    func getVariableLine () -> String {
        return "var " + name + ": " + type + "?"
    }
}
