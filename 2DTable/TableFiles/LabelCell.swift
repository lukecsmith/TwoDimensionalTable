//
//  LabelCell.swift
//  Sensium Mobile Demo
//
//  Created by Luke Smith on 15/01/2019.
//  Copyright © 2019 Sensium Healthcare Ltd. All rights reserved.
//

import Foundation
import UIKit

class LabelCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
    }
}
