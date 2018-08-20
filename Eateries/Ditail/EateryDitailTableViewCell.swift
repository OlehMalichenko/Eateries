//
//  EateryDitailTableViewCell.swift
//  Eateries
//
//  Created by OlehMalichenko on 05.12.2017.
//  Copyright © 2017 OlehMalichenko. All rights reserved.
//

import UIKit

class EateryDitailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
