//
//  FlipClockView.swift
//  FlipClock
//
//  Created by Liu Chuan on 2018/6/2.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


class FlipClockView: UIView {
    
    //MARK: - 属性( Attribute )
    /// 时间
    var date: Date? {
        didSet {
            let calendar = Calendar.current
            let dateComponent = calendar.dateComponents([.hour, .minute, .second], from: self.date!)
            hourItem.time = dateComponent.hour
            minuteItem.time = dateComponent.minute
            secondItem.time = dateComponent.second
        }
    }

    /// 字体
    var font: UIFont? {
        didSet {
            hourItem.font = font
            minuteItem.font = font
            secondItem.font = font
        }
    }
    
    /// 文字颜色
    var textColor: UIColor? {
        didSet {
            hourItem.textColor = textColor
            minuteItem.textColor = textColor
            secondItem.textColor = textColor
        }
    }
    
    //MARK: - 懒加载( Lazy load )
    
    /// 小时
    private lazy var hourItem: FlipClockItem = {
        let hour = FlipClockItem()
        hour.type = .FlipClockItemTypeHour
        return hour
    }()
    
    /// 分钟
    private lazy var minuteItem: FlipClockItem = {
        let minute = FlipClockItem()
        minute.type = .FlipClockItemTypeMinute
        return minute
    }()
    
    /// 秒
    private lazy var secondItem: FlipClockItem = {
        let second = FlipClockItem()
        second.type = .FlipClockItemTypeSecond
        return second
    }()
    
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    /** 布局尺寸必须在 layoutSubViews 中, 否则获取的 size 不正确 **/
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 间距
        let margin: CGFloat = 0.07 * bounds.size.width
        /// 每个item的宽度
        let itemW: CGFloat = (bounds.size.width - 4 * margin) / 3
        /// 每个item的Y值
        let itemY: CGFloat = (bounds.size.height - itemW) / 2
        
        hourItem.frame = CGRect(x: margin, y: itemY, width: itemW, height: itemW)
        minuteItem.frame = CGRect(x: hourItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
        secondItem.frame = CGRect(x: minuteItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 配置UI
extension FlipClockView {
    
    /// 配置UI
    private func configUI() {
        addSubview(hourItem)
        addSubview(minuteItem)
        addSubview(secondItem)
    }
}
