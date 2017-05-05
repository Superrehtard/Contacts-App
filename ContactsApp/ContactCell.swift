//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/4/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit

// Using this custom cell to avoid any potential image loading problems with vanila UITableViewCell.
class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactThumbnailImage : UIImageView!
    @IBOutlet weak var contactNameLabel : UILabel!
    @IBOutlet weak var contactPhoneLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
