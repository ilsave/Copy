//
//  RecentTableViewCell.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 06.04.2021.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    
    
    @IBOutlet var recentNumber: UILabel!
    @IBOutlet var recentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
