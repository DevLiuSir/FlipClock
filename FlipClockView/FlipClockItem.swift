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
    
    //MARK: - 属性( Attribute )
    
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
    
    /// 文字颜色
    var textColor: UIColor? {
        didSet {
            leftLabel.textColor = textColor
            rightLabel.textColor = textColor
        }
    }

    /// 是否第一次设置时间
    var firstSetTime = false
    
    //MARK: - 懒加载( Lazy load )
    
    /// 左边label
    private lazy var leftLabel: FlipClockLabel = FlipClockLabel()
    
    /// 右边label
    private lazy var rightLabel: FlipClockLabel = FlipClockLabel()
    
    /// 最新左边的时间
    private lazy var lastLeftTime: Int = 0
   
    /// 最新右边的时间
    private lazy var lastRightTime: Int = 0
    
    /// 线
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        return line
    }()
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /** 布局尺寸必须在 layoutSubViews 中, 否则获取的 size 不正确 **/
    override func layoutSubviews() {
        super.layoutSubviews()

        let labelW = self.bounds.size.width / 2
        let labelH = self.bounds.size.height
        leftLabel.frame = CGRect(x: 0, y: 0, width: labelW, height: labelH)
        rightLabel.frame = CGRect(x: labelW, y: 0, width: labelW, height: labelH)
        self.layer.cornerRadius = self.bounds.size.height / 10
        self.layer.masksToBounds = true
        line.frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: 5)
    }
    
}

// MARK: - custom method
extension FlipClockItem {
    
    /// 配置UI
    private func configUI() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(line)
        
        lastLeftTime = -1
        lastRightTime = -1
    }
    
    /// 配置左边的时间标签
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

    
    /// 配置右边的时间标签
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
    
}
