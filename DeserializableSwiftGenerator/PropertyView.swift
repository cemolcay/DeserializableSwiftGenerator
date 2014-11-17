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
    
    var property : Property?
    
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
    
    override func awakeFromNib() {
        println("awoke")
    }
    
    @IBAction func nextPressed (sender: AnyObject) {

    }
    
    @IBAction func deletePressed (sender: AnyObject) {

    }
    
    
    // MARK: NSTextFieldDelegate
    
    override func controlTextDidChange(obj: NSNotification) {
        let txt = obj.object as NSTextField
        if (txt == nameField) {
            property!.propertyName = txt.stringValue
            property!.propertyMapName = txt.stringValue
        } else if (txt == typeField) {
            property!.propertyType = txt.stringValue
        } else if (txt == mapField) {
            property!.propertyMapName = txt.stringValue
        }
    }
}
