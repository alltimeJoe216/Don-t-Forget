//
//  SelectSectionCollectionViewCell.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/7/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

class SelectSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var sectionNameLabel: UILabel!
    
    var folderData: ReminderFolder! {
        didSet {
            sectionNameLabel.text = folderData.title
        }
    }
    
}
