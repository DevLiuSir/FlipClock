//
//  SecToneTableViewCell.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/27.
//  Copyright © 2020 Liu Chuan. All rights reserved.
//

import UIKit

class SecToneTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 处理选择状态下的图片隐藏
        let check = contentView.subviews[1] as! UIImageView
        if selected {
            check.isHidden = false
        }else {
            check.isHidden = true
        }
    }
}
