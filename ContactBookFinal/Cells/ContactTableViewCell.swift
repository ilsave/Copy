//
//  ContactTableViewCell.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var surNameLabel: UILabel!
    
    @IBOutlet var customCirle: InitialsCustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        customCirle.name = String(nameLabel.text!.prefix(1)) + String(surNameLabel.text!.prefix(1))
    }
    
}
