//
//  UserTableViewCell.swift
//  iXplore
//
//  Created by David Wallach on 7/12/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        
    }
}
