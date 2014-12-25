//
//  SWGeneratorView.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 25/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

enum GenerateMethod: Int {
    case JSONHelper     = 0
    case ObjectMapper   = 1
}

class SWGeneratorView: NSView {
    
    @IBOutlet var nameTextField: NSTextField!
    @IBOutlet var superTextField: NSTextField!
    
    @IBOutlet var jsonTextView: NSTextView!
    @IBOutlet var generateMethodComboBox: NSPopUpButton!
    
    @IBAction func generatePressed(sender: AnyObject) {
        if validate() {
            generate()
        }
    }
    
    
    func validate () -> Bool {
        if nameTextField.stringValue.isEmpty {
            println("not valid, name empty")
            return false
        }
        
        if countElements(jsonTextView.string!) > 0 {
            println("valid")
            return true
        } else {
            println("not valid json empty")
            return false
        }
    }
    
    func generate () {
        let name: String = nameTextField.stringValue
        var superName: String? = superTextField.stringValue
        
        if superTextField.stringValue.isEmpty {
            superName = nil
        }
        
        let json = jsonTextView.string!
        
        let parser = SWJsonParser ()
        let swclass = parser.generateSWClass(name, superName: superName, json: json)
        
        let method = GenerateMethod (rawValue: generateMethodComboBox.indexOfSelectedItem)!
        switch method {
        case .JSONHelper:
            let gen = JSONHelperGenerator ()
            gen.saveToDesktop(swclass)
            
        case .ObjectMapper:
            let gen = ObjectMapperGenerator ()
            gen.saveToDesktop(swclass)
        }
    }
    
}
