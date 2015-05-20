//
//  EventCellTableViewCell.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
