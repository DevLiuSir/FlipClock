//
//  ClockSecondSwitch.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

/// 时钟秒开关
class ClockSecondSwitch: UIView {
    
    /// 秒切换按钮
    internal lazy var secondSwitch: UISwitch = {
        let uiswitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        // 设置开启颜色
        uiswitch.onTintColor = ThemeManager.sharedInstance.currentTheme.labelBackgroudColor
        // 设置拇指外观着色
        uiswitch.thumbTintColor = ThemeManager.sharedInstance.currentTheme.tintColor
        return uiswitch
    }()
    
    /// 秒标签
    internal lazy var secLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: secondSwitch.frame.maxX + 5, y: 10, width: 25, height: 15))
        label.text = "SEC"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        return label
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(secondSwitch)
        addSubview(secLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
