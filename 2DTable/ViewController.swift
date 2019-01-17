//
//  ViewController.swift
//  2DTable
//
//  Created by Luke Smith on 17/01/2019.
//  Copyright © 2019 LukeSmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var twoDimensionalTable: TwoDimensionalTable!
    
    /*
     Creates some sample data for the table.  In the table, rows are vertical, columns horizontal - as an excel spreadsheet.  The first column in each row is used as a title row, and the contents of that are populated in the tableview on the left.
     */
    var tableData : [[TableDataObject]] {
        let rows = 20
        let columns = 30
        var returnData = [[TableDataObject]]()
        for i in 0...rows {
            var thisRow = [TableDataObject]()
            for j in 0...columns {
                var object : TableDataObject!
                if j == 0 {
                    object = TableDataObject.init(cellText: "Row \(i)")  //label title column
                } else {
                    object = TableDataObject.init(cellText: "c\(j), r\(i)") //normal data entry
                }
                thisRow.append(object)
            }
            returnData.append(thisRow)
        }
        return returnData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.twoDimensionalTable.refreshWithData(data: self.tableData)
    }
    
    

}

