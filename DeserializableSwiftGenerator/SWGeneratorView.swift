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
        if isValid() {
            let button = sender as! NSButton
            button.enabled = false
            generate()
            button.enabled = true
        }
    }
    
    override func awakeFromNib() {
        jsonTextView.font = NSFontManager.sharedFontManager()
            .fontWithFamily("Menlo",
                traits: NSFontTraitMask.BoldFontMask,
                weight: 1,
                size: 11)
    }

    func isValid () -> Bool {
        if nameTextField.stringValue.isEmpty {
            Swift.print("not valid, name empty")
            return false
        }
        if (jsonTextView.string!).characters.count > 0 {
            Swift.print("valid")
            return true
        } else {
            Swift.print("not valid json empty")
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
        let parser = SWJsonParser()
        let classes = parser.parseJsonToSWClass(name, superName: superName, jsonString: json)
        var gen: SWGenerator!
        let method = GenerateMethod (rawValue: generateMethodComboBox.indexOfSelectedItem)!
        switch method {
            case .JSONHelper:
                gen = JSONHelperGenerator()
                
            case .ObjectMapper:
                gen = ObjectMapperGenerator()
        }
        for sw in classes {
            gen.saveToDesktop(sw)
        }
    }
}
