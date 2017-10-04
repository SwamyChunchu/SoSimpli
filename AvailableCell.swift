//
//  AvailableCell.swift
//  SOSIMPLE
//
//  Created by think360 on 12/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class AvailableCell: UITableViewCell {

    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var bookingIDLbl: UILabel!
    @IBOutlet weak var assignedStateImg: UIImageView!
    
    @IBOutlet weak var lastLineLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
