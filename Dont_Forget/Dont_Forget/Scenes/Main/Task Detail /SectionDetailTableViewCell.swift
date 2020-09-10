//
//  SectionDetailTableViewCell.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/8/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

class SectionDetailTableViewCell: UITableViewCell {

    @IBOutlet var reminderTitle: UILabel!
    @IBOutlet var completedCircleImage: UIImageView!
    
    var reminderData: Reminder! {
        didSet {
            reminderTitle.text = reminderData.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
