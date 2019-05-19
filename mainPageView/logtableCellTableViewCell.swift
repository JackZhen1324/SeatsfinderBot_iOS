//
//  logtableCellTableViewCell.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/17/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class logtableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var targetCourse: UILabel!
    @IBOutlet weak var jobID: UILabel!
    
    @IBOutlet weak var mod: UILabel!
    @IBOutlet weak var logs: UILabel!
    @IBOutlet weak var count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
