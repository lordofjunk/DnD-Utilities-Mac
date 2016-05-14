//
//  ViewController.swift
//  DnD Utilities
//
//  Created by Austin Phillips on 5/9/16.
//  Copyright © 2016 Quantum Enriched Development. All rights reserved.
//

import Cocoa

class RollerViewController: NSViewController {
    
    // Custom Scructs Necessary
    struct DiceSet {
        let name: String
        let numDice: Int
        let numSides: Int
        let mod: Int
    }
    
    // Variables Necessary
    var setBag: [DiceSet] = []
        
    // Outlets
    @IBOutlet weak var RollsTable: NSTableView!
    @IBOutlet weak var ResultText: NSTextField!
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting ourselves to be delegates and data sources
        RollsTable.setDelegate(self)
        RollsTable.setDataSource(self)
        
        // Miscellaneous set up
        // setBag.append(DiceSet(name: "Test", numDice: 1, numSides: 6, mod: 1))
        ResultText.stringValue = ""
        
        // Reloading all necessary things
        RollsTable.reloadData()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // Fuctions
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
    
    func addDiceSet(name: String, numberOfDice: Int, numberOfSides: Int, modifier: Int) {
        setBag.append(DiceSet(name: name, numDice: numberOfDice, numSides: numberOfSides, mod: modifier))
    }
    
    // IBActions
    @IBAction func AddRemoveButtons(sender: AnyObject) {
        let seg = sender.selectedSegment
        if seg == 0 {
            performSegueWithIdentifier("AddDieSegue", sender: self)
        }
        else if seg == 1{
            if RollsTable.selectedRow >= 0 && RollsTable.selectedRow < setBag.count {
                setBag.removeAtIndex(RollsTable.selectedRow)
            }
        }
        RollsTable.reloadData()
    }
    @IBAction func RollSelected(sender: AnyObject) {
        if RollsTable.selectedRow >= 0 && RollsTable.selectedRow < setBag.count {
            let index = RollsTable.selectedRow
            ResultText.stringValue = String(RollDiceSet(setBag[index].numDice, numSides: setBag[index].numSides, mod: setBag[index].mod))
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddDieSegue" {
            let destination = segue.destinationController as! AdderRollerViewController
            destination.cheatyParent = self
        }
    }
}



// Extensions
extension RollerViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return setBag.count
    }
}

extension RollerViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var contents: String = ""
        var cellIdentifier: String = ""
        
        if setBag.count == 0 {
            return nil
        }
        
        let item = setBag[row]
        
        if tableColumn == tableView.tableColumns[0] {
            contents = item.name
            cellIdentifier = "DieNameID"
        }
        else if tableColumn == tableView.tableColumns[1] {
            contents = String(item.numDice)
            cellIdentifier = "DieNumberID"
        } else if tableColumn == tableView.tableColumns[2] {
            contents = "d\(item.numSides)"
            cellIdentifier = "DieTypeID"
        } else if tableColumn == tableView.tableColumns[3] {
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
