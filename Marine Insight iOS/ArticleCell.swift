//
//  ArticleCell.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 28/04/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var postTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
