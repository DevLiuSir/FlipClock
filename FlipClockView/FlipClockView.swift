//
//  FlipClockView.swift
//  FlipClock
//
//  Created by Liu Chuan on 2018/6/2.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


class FlipClockView: UIView {
    
    //MARK: - Attribute
    
    /// 创建日历对象
    var calendar = Calendar.current
    /// 日期的组件
    var dateComponent: DateComponents!
    
    /// 时间
    var date: Date? {
        didSet {
            //默认情况下，日历未设置语言环境。
            //如果您希望收到本地化的答案，请务必首先将locale属性设置为。Locale.autoupdatingCurrent
            calendar.locale = Locale.autoupdatingCurrent
            
            // NSDateComponents默认是24小时制式
            dateComponent = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: self.date!)
            
            // 如果为十二小时制，且当前时间大于12小时，转换当前时间24小时制到12小时制
            if is12HourClock && dateComponent.hour! > 12 {
                dateComponent.hour! -= 12
            }
            
            hourItem.time = dateComponent?.hour
            minuteItem.time = dateComponent?.minute
            secondItem.time = dateComponent?.second
            
            weekdayLabel.text = getWeekdayWithNumber(dateComponent.weekday!)
            yearToDateLabel.text = "\(dateComponent.year!)年\(dateComponent.month!)月\(dateComponent.day!)日"
        }
    }
    
    /// 是否为十二小时制  (默认：24小时制。FALSE,)
    var is12HourClock: Bool = false {
        didSet {
            if is12HourClock != oldValue {
                print("----- 12小时制 -------")
                let dateText = convertTimeFormat()
                timeSystemLabel.text = dateText
            }else {
                print("----- 24小时制 -----")
            }
        }
    }
    
    /// 是否可见工作日、普通日 。(星期天及星期六以外的) 任何一天
    var weekdayIsVisible: Bool = false {
        didSet {
            if weekdayIsVisible != oldValue {
                weekdayLabel.isHidden = false
            }else {
                weekdayLabel.isHidden = true
            }
        }
    }
    
    /// 秒是否可见
    var secondIsVisible: Bool = false {
        didSet {
            if secondIsVisible != oldValue {
                secondItem.isHidden = false
            }else {
                secondItem.isHidden = true
            }
        }
    }
    
    /// 年月日是否可见
    var yearMonthDayIsVisible: Bool = false {
        didSet {
            if yearMonthDayIsVisible != oldValue {
                yearToDateLabel.isHidden = false
            }else {
                yearToDateLabel.isHidden = true
            }
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
    
    //MARK: - Lazy loading
    
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
    
    /// 时间制式label
    private lazy var timeSystemLabel: UILabel = {
        let timeSystemLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 215, height: 30))
        timeSystemLabel.textColor = .lightText
        timeSystemLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        timeSystemLabel.backgroundColor = .clear
        return timeSystemLabel
    }()
    
    /// 工作日label
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: 215, height: 30))
        label.textColor = .lightText
        label.isHidden = true   // 默认为：隐藏
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 年月日label
    private lazy var yearToDateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: 215, height: 30))
        label.textColor = .lightText
        label.isHidden = true   // 默认为：隐藏
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        label.backgroundColor = .clear
        return label
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
extension FlipClockView {
    
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
}

// MARK: - Configuration
extension FlipClockView {
    
    private func configUI() {
        addSubview(hourItem)
        addSubview(minuteItem)
        addSubview(secondItem)
        hourItem.addSubview(timeSystemLabel)
        minuteItem.addSubview(weekdayLabel)
        secondItem.addSubview(yearToDateLabel)
    }
}

//MARK: - Convert Time Format
extension FlipClockView {
    
    /// 转换时间制式 （24 - > 12小时制）
    ///
    /// - Returns: String
    func convertTimeFormat() -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh-CN")
        // 设置时间格式
        //“ a”是AM / PM指示符的ICU符号。它永远不可能是“ A”，因为ICU使用“ A”来表示完全不同的东西（一天中的毫秒数）。
        df.dateFormat = "a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        // 设置时区
        df.timeZone = TimeZone(identifier: "Asia/Shanghai")
        print("当前时区-\(TimeZone.current)----\(NSTimeZone.system)")
        
        // 调用string方法进行转换
        let dateString = df.string(from: Date())
        print(dateString)   // "PM"
        return dateString
    }
    
    /// 根据数字获取工作日
    /// - Parameter number: 数字
    func getWeekdayWithNumber(_ number: Int) -> String? {
        switch number {
        case 1:
            return "星期日"
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        default:
            return ""
        }
    }
}
