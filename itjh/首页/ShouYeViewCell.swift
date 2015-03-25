//
//  ShouYeViewCell.swift
//  itjh
//
//  Created by 黄成都 on 15/2/2.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit

class ShouYeViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.font = UIFont.systemFontOfSize(16)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
