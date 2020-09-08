//
//  ReminderFolderTableViewCell.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

class ReminderFolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var sectionNameLabel: UILabel!
    //MARK: - Properties
    
//    var isInEditingMode: Bool = false {
//        didSet {
//            checkmarkLabel.isHidden = !isInEditingMode
//        }
//    }
//
//    // 2
//    override var isSelected: Bool {
//        didSet {
//            if isInEditingMode {
//                checkmarkLabel.text = isSelected ? "✓" : ""
//            }
//        }
//    }

    
    static var reuseIdentifier: String = "reminderFolderCell"
    
    var folderData: ReminderFolder! {
        didSet {
            sectionNameLabel.text = folderData.title
            let count = CoreDataManager.shared.fetchNotes(from: folderData).count
            countLabel.text = String("\(count)  ")
        }
    }
}
