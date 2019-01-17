//
//  UIView_Extension.swift
//  2DTable
//
//  Created by Luke Smith on 17/01/2019.
//  Copyright © 2019 LukeSmith. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func autolayoutIntoSuperview() {
        guard let superview = self.superview else {
            print("=== Unable to add view into superview - no superview exists")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
