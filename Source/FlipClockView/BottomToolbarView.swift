//
//  BottomToolbarView.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

class BottomToolbarView: UIView {
    
    /// 显示模式（本地存储...按钮的状态）
    private let displayMode = UserDefaults.standard.bool(forKey: "DisplayMode")
    /// 间距
    private let padding: CGFloat = 20
    /// 最小Y值
    private let minY: CGFloat = 10
    
    /// 主题切换按钮
    internal lazy var themeSwitchButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: padding, y: minY, width: 30, height: 30))
        btn.tintColor = ThemeManager.sharedInstance.currentTheme.tintColor
        btn.backgroundColor = ThemeManager.sharedInstance.currentTheme.labelBackgroudColor
        btn.layer.cornerRadius = 5
        // 设置不同模式下的图片
        btn.setImage(UIImage(systemName: displayMode ? "moon.fill" : "sun.min.fill"), for: .normal)
        return btn
    }()
    
    /// 静音按钮
    internal lazy var silentButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: themeSwitchButton.frame.maxX + padding,
                                         y: minY, width: 30, height: 30))
        btn.tintColor = ThemeManager.sharedInstance.currentTheme.tintColor
        btn.backgroundColor = ThemeManager.sharedInstance.currentTheme.labelBackgroudColor
        btn.layer.cornerRadius = 5
        btn.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        btn.setImage(UIImage(systemName: "speaker.slash.fill"), for: .selected)
        return btn
    }()
    
    /// 时钟秒开关视图
    internal lazy var clockSecondSwitch: ClockSecondSwitch = {
        let swicth = ClockSecondSwitch(frame: CGRect(x: silentButton.frame.maxX + padding,
                                                     y: minY, width: 100, height: 30))
        return swicth
    }()
    
    /// 设置按钮
    internal lazy var settingsButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: frame.maxX - 100, y: minY, width: 30, height: 30))
        btn.tintColor = ThemeManager.sharedInstance.currentTheme.tintColor
        btn.backgroundColor = ThemeManager.sharedInstance.currentTheme.labelBackgroudColor
        btn.layer.cornerRadius = 5
        btn.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        return btn
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(themeSwitchButton)
        addSubview(silentButton)
        addSubview(clockSecondSwitch)
        addSubview(settingsButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
