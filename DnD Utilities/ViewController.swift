//
//  ViewController.swift
//  DnD Utilities
//
//  Created by Austin Phillips on 5/9/16.
//  Copyright © 2016 Quantum Enriched Development. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let diceBag = ["Select a Die!":0,"d4":4,"d6":6,"d8":8,"d10":10,"d12":12,"d20":20,"d100":100]
    @IBOutlet weak var DieSelection: NSPopUpButton!
    @IBOutlet weak var ResultField: NSTextField!
    @IBOutlet weak var NumberOfDice: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for die in diceBag.keys.sort({diceBag[$0] < diceBag[$1]}) {
            DieSelection.addItemWithTitle(die)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func RollDice(sender: AnyObject) {
        if  ((Int(NumberOfDice.stringValue) != nil) && (diceBag[DieSelection.titleOfSelectedItem!]! != 0)){
            func roll(sides: Int) -> Int {
                return Int(arc4random_uniform(UInt32(sides)))+1
            }
            var total = 0
            let sides = diceBag[DieSelection.titleOfSelectedItem!]!
            for _ in 1...Int(NumberOfDice.stringValue)! {
                total += roll(sides)
            }
            ResultField.stringValue = String(total)
        }
    }

}

