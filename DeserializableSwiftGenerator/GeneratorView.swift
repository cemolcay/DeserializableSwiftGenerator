//
//  GeneratorView.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Foundation
import AppKit


let DefaultSuperClass : String = "NSObject"

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}

enum GenerationMode : Int {
    case FromList
    case FromJson
}

class GeneratorView: NSView, NSTableViewDataSource, NSTableViewDelegate {
    
    
    // MARK: IBOutlets
    
    @IBOutlet var classField: NSTextField!
    @IBOutlet var superClassField: NSTextField!
    
    @IBOutlet var tabView: NSTabView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var jsonTextView: NSTextView!
    
    
    
    // MARK: Generator
    
    var awakeFromNibHack: Int = 0
    lazy var properties : [Property] = {
        return []
    }()
    
    
    override func awakeFromNib() {
        if awakeFromNibHack++ > 0 {
            return
        }

        // register property view cell nib
        let nib = NSNib (nibNamed: "PropertyView", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib!, forIdentifier: "PropertyViewCell")
        
        addProperty()
    }
    
    
    func addProperty () {
        let prop = Property (name: "", type: "", mapName: "")
        properties.append(prop)
        tableView!.reloadData()
    }
    
    func deleteProperty (property: Property) {
        properties.removeObject(property)
        tableView.reloadData()
        
    }
    
    
    @IBAction func addPressed (sender: AnyObject) {
        addProperty()
    }
    
    @IBAction func generatePressed (sender: AnyObject) {
        if isValid() {
            let generator = Generator ()
            let name = classField.stringValue
            let superName = superClassField.stringValue
            
            switch generationMode() {
                case .FromJson:
                    let jsonString = jsonTextView.string!
                    generator.generate(name, superClassName: superName, jsonString: jsonString)

                case .FromList:
                    generator.generate(name, superClassName: superName, properties: properties)
                default:
                    return
            }
        }
    }
    
    
    func isValid () -> Bool {
        let c = countElements(classField.stringValue)
        let sc = countElements(superClassField.stringValue)
        
        if (c == 0) {
            return false
        }
        
        if superClassField.stringValue.isEmpty {
            superClassField.stringValue = DefaultSuperClass
        }
        
        if (generationMode() == GenerationMode.FromList) {
            if (properties.count == 0) {
                
            }
        }
        
        return true
    }
    
    func generationMode () -> GenerationMode {
        var index = tabView.indexOfTabViewItem(tabView.selectedTabViewItem!)
        let gm = GenerationMode (rawValue: tabView.indexOfTabViewItem(tabView.selectedTabViewItem!))!
        return gm
    }

    
    
    // MARK: NSTableViewDataSoruce
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return properties.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var propertyView = tableView.makeViewWithIdentifier("PropertyViewCell", owner: self) as PropertyView
        propertyView.property = properties[row]
        propertyView.generatorView = self
        propertyView.nameField?.becomeFirstResponder()
        return propertyView
    }
}
