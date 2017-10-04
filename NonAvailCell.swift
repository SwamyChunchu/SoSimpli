//
//  NonAvailCell.swift
//  SOSIMPLE
//
//  Created by think360 on 12/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class NonAvailCell: UITableViewCell {
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var zoneLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
