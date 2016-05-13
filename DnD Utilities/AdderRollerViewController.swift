//
//  AdderRollerViewController.swift
//  DnD Utilities
//
//  Created by Austin Phillips on 5/13/16.
//  Copyright © 2016 Quantum Enriched Development. All rights reserved.
//

import Cocoa

class AdderRollerViewController: NSViewController {
    
    var cheatyParent: RollerViewController?
    
    let diceBag = ["Select a Die!":0,"d4":4,"d6":6,"d8":8,"d10":10,"d12":12,"d20":20,"d100":100]
    
    @IBOutlet weak var NameField: NSTextField!
    @IBOutlet weak var TypeSelector: NSPopUpButton!
    @IBOutlet weak var NumberDisplay: NSTextField!
    @IBOutlet weak var NumberStepper: NSStepper!
    @IBOutlet weak var ModifierDisplay: NSTextField!
    @IBOutlet weak var ModifierStepper: NSStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NumberStepper.minValue = 1
        ModifierStepper.minValue = -ModifierStepper.maxValue
        
        for key in diceBag.keys.sort({diceBag[$0] < diceBag[$1]}) {
            TypeSelector.addItemWithTitle(key)
        }
    }
    
    @IBAction func SubmitButton(sender: AnyObject) {
        cheatyParent!.addDiceSet(NameField.stringValue, numberOfDice: Int(NumberStepper.intValue), numberOfSides: diceBag[TypeSelector.selectedItem!.title]!, modifier: Int(ModifierStepper.intValue))
        cheatyParent!.RollsTable.reloadData()
        self.dismissViewController(self)
    }
    
    @IBAction func CancelButton(sender: AnyObject) {
        self.dismissViewController(self)
    }
    
    @IBAction func ResetButton(sender: AnyObject) {
        NumberDisplay.stringValue = "1"
        NumberStepper.intValue = 1
        ModifierDisplay.stringValue = "0"
        ModifierStepper.intValue = 0
        TypeSelector.selectItemAtIndex(0)
    }
    
    @IBAction func UpdateNumberStepper(sender: AnyObject) {
        NumberDisplay.stringValue = String(NumberStepper.intValue)
    }
    
    @IBAction func UpdateModifierStepper(sender: AnyObject) {
        ModifierDisplay.stringValue = String(ModifierStepper.intValue)
    }
    
}
