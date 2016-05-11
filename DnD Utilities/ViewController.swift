//
//  ViewController.swift
//  DnD Utilities
//
//  Created by Austin Phillips on 5/9/16.
//  Copyright © 2016 Quantum Enriched Development. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    struct DiceSet {
        let numDice: Int;
        let numSides: Int;
        let mod: Int;
    }
    
    var setBag: [DiceSet] = []
    let diceBag = ["Select a Die!":0,"d4":4,"d6":6,"d8":8,"d10":10,"d12":12,"d20":20,"d100":100]
    @IBOutlet weak var DieSelection: NSPopUpButton!
    @IBOutlet weak var ResultField: NSTextField!
    @IBOutlet weak var NumberOfDice: NSTextField!
    @IBOutlet weak var Modifier: NSTextField!
    @IBOutlet weak var RollsTable: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ResultField.stringValue = ""
        for die in diceBag.keys.sort({diceBag[$0] < diceBag[$1]}) {
            DieSelection.addItemWithTitle(die)
        }
        
        setBag.append(DiceSet(numDice: 2, numSides: 6, mod: 0))
        
        RollsTable.setDelegate(self)
        RollsTable.setDataSource(self)
        
        RollsTable.reloadData()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func RollDiceSet(numDice: Int, numSides: Int, mod: Int = 0) -> Int {
        func roll(sides: Int) -> Int {
            return Int(arc4random_uniform(UInt32(sides)))+1
        }
        var total = 0
        for _ in 1...numDice {
            total += roll(numSides)
        }
        total += mod
        return total
    }

    @IBAction func RollButton(sender: AnyObject) {
        if  (diceBag[DieSelection.titleOfSelectedItem!]! != 0){
            ResultField.stringValue = String(RollDiceSet(Int(NumberOfDice.stringValue) ?? 1, numSides: diceBag[DieSelection.titleOfSelectedItem!]!, mod: Int(Modifier.stringValue) ?? 0))
        }
    }
    
}

extension ViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return setBag.count
    }
}

extension ViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
        var contents: String = ""
        var cellIdentifier: String = ""
        
        if setBag.count == 0 {
            return nil
        }
        
        let item = setBag[row]
        
        if tableColumn == tableView.tableColumns[0] {
            contents = String(item.numDice)
            cellIdentifier = "DieNumberID"
        } else if tableColumn == tableView.tableColumns[1] {
            contents = "d\(item.numSides)"
            cellIdentifier = "DieTypeID"
        } else if tableColumn == tableView.tableColumns[2] {
            contents = String(item.mod)
            cellIdentifier = "DieModifierID"
        }
        
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = contents
            return cell
        }
        return nil
    }
}
