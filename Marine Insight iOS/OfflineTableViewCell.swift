//
//  OfflineTableViewCell.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 30/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class OfflineTableViewCell: UITableViewCell {

    @IBOutlet weak var offImage: UIImageView!
    @IBOutlet weak var offTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
