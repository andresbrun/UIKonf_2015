//
//  FriendCell.swift
//  FriendsGlue
//
//  Created by Andres Brun Moreno on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = CGRectGetHeight(icon.frame) * 0.5
    }
}
