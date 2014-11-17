//
//  PropertyView.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class PropertyView: NSView, NSTextFieldDelegate {

    @IBOutlet var nameField : NSTextField?
    @IBOutlet var typeField : NSTextField?
    @IBOutlet var mapField : NSTextField?
    
    var generatorView : GeneratorView?
    var property : Property?
    
    var addNextHack : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var layer = CALayer ()
        layer.backgroundColor = NSColor.yellowColor().CGColor
        layer.masksToBounds = true
        self.layer = layer
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addNextProperty () {
        if (addNextHack++ == 0) {
            generatorView?.addProperty()
        }
    }

    
    // MARK: NSTextFieldDelegate
    
    override func controlTextDidChange(obj: NSNotification) {
        let txt = obj.object as NSTextField
        if (txt == nameField) {
            property!.propertyName = txt.stringValue
            property!.propertyMapName = txt.stringValue
            
            if (countElements(txt.stringValue) > 0) {
                addNextProperty()
            } else {
                generatorView!.deleteProperty(self.property!)
            }
            
        } else if (txt == typeField) {
            property!.propertyType = txt.stringValue
        } else if (txt == mapField) {
            property!.propertyMapName = txt.stringValue
        }
    }
    
    func control(control: NSControl, textView: NSTextView, completions words: [AnyObject], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [AnyObject] {
        if (textView == typeField) {
            var result = []
            let string = textView.string
            
            if (string == "S" || string == "s") {
                result = ["String"]
            } else if (string == "F") {
                result = ["Float"]
            } else if (string == "C") {
                result = ["CGFloat"]
            } else if (string == "i" || string == "I") {
                result == ["Int"]
            }
            
            return result
        }
        
        return []
    }
    
}
