//
//  AppDelegate.swift
//  DeserializableSwiftGenerator
//
//  Created by Cem Olcay on 14/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa
import Foundation
import AppKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var generatorView: GeneratorView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    
    }

    
    func testGenerator () {
        let t1 = Property (name: "name", type: "String", mapName: "Name")
        let t2 = Property (name: "surname", type: "String", mapName: "SurName")
        let t3 = Property (name: "age", type: "Int", mapName: "Age")
        
        var c = ClassObject ()
        c.name = "User"
        c.superClassName = "BaseResponse"
        c.properties = [t1, t2, t3]
        
        let gen = Generator()
        gen.generate(c)
    }

    
    func testFromJSONGenerator () {
        let gen = Generator ()
        gen.generate("YSUser", superClassName: "BaseResponse", jsonString: "{\"value\": \"New\", \"onclick\": \"CreateNewDoc\", \"points\":28, \"floats\":28.5}")
    }
    
}

