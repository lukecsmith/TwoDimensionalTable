//
//  CollectionViewCell.swift
//  Sensium Mobile Demo
//
//  Created by Luke Smith on 07/01/2019.
//  Copyright © 2019 Sensium Healthcare Ltd. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func prepareForReuse() {
        self.label.text = ""
        self.label.textColor = UIColor.white
    }
}
