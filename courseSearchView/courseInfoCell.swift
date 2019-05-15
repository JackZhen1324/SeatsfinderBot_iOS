//
//  courseInfoCell.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/8/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class courseInfoCell: UITableViewCell {

    @IBOutlet weak var courseID: UILabel!
    @IBOutlet weak var instructorIndo: UILabel!
    

    @IBOutlet weak var termInfo: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseStatus: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
