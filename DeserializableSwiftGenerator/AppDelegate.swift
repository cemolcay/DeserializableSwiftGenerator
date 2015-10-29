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
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let testCamel = "hello_world"
        Swift.print(testCamel.camelCasedString)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    
    }

    func testGenerator () {
        print("test starting")
        
        let p1 = SWProperty (name: "name", type: "String")
        let p2 = SWProperty (name: "surname", type: "String")
        let p3 = SWProperty (name: "age", type: "Int")
        
        let c = SWClass (name: "Person", superName: "TestSuper", properties: [p1, p2, p3])
        
        let gen  = ObjectMapperGenerator ()
        let save = gen.saveToDesktop(c)
        print("did save \(save)")
    }
}

