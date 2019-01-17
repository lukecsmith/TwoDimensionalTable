//
//  TwoDimensionalTable.swift
//  2DTable
//
//  Created by Luke Smith on 17/01/2019.
//  Copyright © 2019 LukeSmith. All rights reserved.
//

import Foundation
import UIKit

/*
 This 2D table consists of three parts : a UICollectionView that shows all the data, scrolling horizontally.  A UITableView displaying the labels for each row, on the left.  This is separate to the collection view so that it can float over the top of it and stay visible while scrolling the scores horizontally.  Finally both of these are embedded inside a UIScrollview, that scrolls vertically, allowing for any number of rows to be displayed.
 
 In the startup func, the scrollview is first added, then the collection view and tableview are added into a content view that has been added to the scrollview.  The setup of the scrollview allows for autolayout rules to govern the size of the content view.  Brief explanation of setup : a content view is added to the scrollview.  Top, bottom, leading and trailing of the content view are pinned to the scrollview same points.  Then width and height of the content view are also pinned to be the same as the scrollview, but the height is given a low priority.  This then allows the autolayout height sizes within the content view to take priority.  In practise this means that if the contents of the content view have a combined height of more than the content view, and are pinned to the top and bottom of it, this will make the content view itself expand in height, and therefore the scrollview will scroll vertically to display the content.
 
 We add the uicollectionview and the uitableview to this content view, and when we get new data and the 'refresh' func is called, this calls the 'setScrollviewContentSize' function.  In here we manually set the height of the content view by : calculating no of rows in the table, getting the manually set value for the height of each row, working out the px height required, and setting the collectionview height constraint to this value.  As explained above, this pushes the parent content view to the same height, which makes the scrollview allow vertical scrolling to the correct amount.
 
 The tableview is simply pinned to the top and bottom of the content view, so this expands with the collectionview and the content view when the collectionview height is set.
 
 The collectionview uses a layout called FlowLayout.  It a standard layout provided by apple that allows for content to be set in Sections horizontally, and items vertically.  It is set up fairly simply, to fill the space provided to it, as we manually set the cell height in the FlowLayoutDelegate extension at the bottom of this file.  By using this layout we can lay out the data as given to us in the array, with section corresponding to a set of data, and item corresponding to a row in the data.
 */

class TwoDimensionalTable : UIView {
    
    let sectionInsets = UIEdgeInsets(top:0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var contentView: UIView!
    var collectionViewHeight: NSLayoutConstraint!
    var collectionView: UICollectionView!
    var labelTableView: UITableView!
    let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    let tableViewCellIdentifier = "tableViewCellIdentifier"
    
    //sizes
    let labelWidth : CGFloat = 70.0
    let cellHeight : CGFloat = 40.0
    let cellWidth : CGFloat = 50.0
    
    var tableData: [[TableDataObject]]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.startup()
    }
    
    func startup() {
        self.addScrollView()
        self.addCollectionView()
        self.addLegendTableView()
        self.setNeedsLayout()
    }
    
    func refreshWithData(data : [[TableDataObject]]) {
        self.tableData = data
        self.setScrollViewContentSize()
        self.collectionView?.reloadData()
        self.labelTableView.reloadData()
    }
    //MARK: Scrollview table setup
    func addScrollView() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.autolayoutIntoSuperview()
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.autolayoutIntoSuperview()
        self.contentView = contentView
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        let scrollViewHeight = NSLayoutConstraint(item: contentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        scrollViewHeight.isActive = true
        scrollViewHeight.priority = .defaultLow
        scrollView.addConstraint(scrollViewHeight)
    }
    
    func setScrollViewContentSize() {
        let noRows = self.tableView(labelTableView, numberOfRowsInSection: 0)
        let contentHeight = CGFloat(noRows) * self.cellHeight
        self.collectionViewHeight.constant = contentHeight
        self.setNeedsLayout()
    }
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: self.collectionViewCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.black
        self.contentView.addSubview(collectionView)
        collectionView.autolayoutIntoSuperview()
        let collectionViewHeight = NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
        collectionViewHeight.isActive = true
        collectionViewHeight.priority = UILayoutPriority.init(1000.0)
        self.contentView.addConstraint(collectionViewHeight)
        self.collectionViewHeight = collectionViewHeight
        self.collectionView = collectionView
    }
    
    func addLegendTableView() {
        let legend = UITableView.init()
        self.contentView.addSubview(legend)
        legend.estimatedRowHeight = self.cellHeight
        legend.rowHeight = UITableView.automaticDimension
        legend.dataSource = self
        legend.delegate = self
        legend.separatorStyle = .none
        legend.translatesAutoresizingMaskIntoConstraints = false
        legend.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        legend.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        legend.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        legend.widthAnchor.constraint(equalToConstant: self.labelWidth).isActive = true
        legend.isUserInteractionEnabled = false
        let nib = UINib(nibName: "LabelCell", bundle: nil)
        legend.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
        self.labelTableView = legend
    }
}
//MARK: Collection view datasource, delegate
extension TwoDimensionalTable : UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Sections equate to columns in the table
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if tableData.count > 0 {
            return tableData[0].count - 1 //remove one for the label tableview on the left
        } else {
            return 0
        }
    }
    //items in section equates to rows in a column
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tableData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath)
        if let collectionCell = cell as? CollectionViewCell {
            if self.tableData.count > indexPath.row {
                let row = indexPath.row
                let rowResults = tableData[row]
                if rowResults.count > indexPath.section + 1 {
                    collectionCell.label.text = rowResults[indexPath.section + 1].cellText
                }
            }
        }
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension TwoDimensionalTable : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
//MARK: Tableview for Legend on the left
extension TwoDimensionalTable: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        if let cell = tableCell as? LabelCell {
            cell.cellHeight.constant = self.cellHeight
            cell.separatorInset = UIEdgeInsets.zero
            
            if self.tableData[indexPath.row].count > 0 {
                let rowData = tableData[indexPath.row]
                cell.titleLabel.text = rowData[0].cellText
            }
        }
        return tableCell
    }
}
