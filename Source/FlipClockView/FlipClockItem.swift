//
//  FlipClockItem.swift
//  FlipClock
//
//  Created by Liu Chuan on 2018/6/2.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


/// 时钟item类型
///
/// - FlipClockItemTypeHour: 小时
/// - FlipClockItemTypeMinute: 分
/// - FlipClockItemTypeSecond: 秒
enum FlipClockItemType {
    case FlipClockItemTypeHour
    case FlipClockItemTypeMinute
    case FlipClockItemTypeSecond
}

class FlipClockItem: UIView {
    
    //MARK: Attribute
    
    /// 类型
    var type: FlipClockItemType = .FlipClockItemTypeHour
    
    /// 时间
    var time: Int? {
        didSet {
            configLeftTimeLabel(time! / 10)
            configRightTimeLabel(time! % 10)
        }
    }
    
    /// 字体
    var font: UIFont? {
        didSet {
            leftLabel.font = font
            rightLabel.font = font
        }
    }
    
    //MARK: Lazy loading
    
    /// 左边label
    private lazy var leftLabel: FlipClockLabel = FlipClockLabel()
    
    /// 右边label
    private lazy var rightLabel: FlipClockLabel = FlipClockLabel()
    
    /// 最新左边的时间
    private lazy var lastLeftTime: Int = 0
   
    /// 最新右边的时间
    private lazy var lastRightTime: Int = 0
    
    /// 分割线
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeManager.sharedInstance.currentTheme.lineColor
        return line
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle
extension FlipClockItem {
    
    /** 布局尺寸必须在 layoutSubViews 中, 否则获取的 size 不正确 **/
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelW = bounds.size.width / 2
        let labelH = bounds.size.height
        leftLabel.frame = CGRect(x: 0, y: 0, width: labelW, height: labelH)
        leftLabel.textAlignment = .right
        rightLabel.frame = CGRect(x: labelW, y: 0, width: labelW, height: labelH)
        rightLabel.textAlignment = .left
        line.frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: 5)
        layer.cornerRadius = bounds.size.height / 10
        layer.masksToBounds = true
    }
}

// MARK: - Configuration
extension FlipClockItem {
    
    private func configUI() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(line)
        
        lastLeftTime = -1
        lastRightTime = -1
    }
    
    /// 配置左边的时间
    ///
    /// - Parameter time: 时间
    private func configLeftTimeLabel(_ time: Int) {
        if lastLeftTime == time && lastLeftTime != -1 {
            return
        }
        lastLeftTime = time
        var current: Int = 0
        switch type {
        case .FlipClockItemTypeHour:
            current = time == 0 ? 2 : time - 1
        case .FlipClockItemTypeMinute:
            current = time == 0 ? 5 : time - 1
        case .FlipClockItemTypeSecond:
            current = time == 0 ? 5 : time - 1
        }
        leftLabel.updateTime(current, nextTime: time)
    }
    
    /// 配置右边的时间
    ///
    /// - Parameter time: 时间
    private func configRightTimeLabel(_ time: Int) {
        if lastRightTime == time && lastRightTime != -1 {
            return
        }
        lastRightTime = time
        var current: Int = 0
        switch type {
        case .FlipClockItemTypeHour:
            current = time == 0 ? 4 : time - 1
        case .FlipClockItemTypeMinute:
            current = time == 0 ? 9 : time - 1
        case .FlipClockItemTypeSecond:
            current = time == 0 ? 9 : time - 1
        }
        rightLabel.updateTime(current, nextTime: time)
    }
    
    /// 更新Label的主题颜色
    /// - Parameter theme: 当前主题
    public func updateLabelThemeColor(_ theme: ThemeProtocol) {
        leftLabel.currentBackgroundColor = theme.labelBackgroudColor
        rightLabel.currentBackgroundColor = theme.labelBackgroudColor
        leftLabel.currentTextColor = theme.textColor
        rightLabel.currentTextColor = theme.textColor
        line.backgroundColor = theme.lineColor
    }
}
