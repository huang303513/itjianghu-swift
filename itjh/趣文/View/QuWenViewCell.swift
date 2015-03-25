//
//  QuWenViewCell.swift
//  itjh
//
//  Created by 黄成都 on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit

class QuWenViewCell: UITableViewCell {

    
    @IBOutlet weak var quwentextView: UITextView!
    
    
    @IBOutlet weak var quwenPictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
