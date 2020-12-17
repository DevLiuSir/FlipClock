//
//  FlipClockView.swift
//  FlipClock
//
//  Created by Liu Chuan on 2018/6/2.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit
import AudioToolbox


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
            
            print("sec:  \(dateComponent.second!)")
            
            // MARK: 处理音效播放 (Processing sound effect playback)
            // 如果秒不可见，1分钟、1小时播放一次
            // dateComponent.second! / 59 == 1 : 1分钟
            // dateComponent.minute! / 59 == 1 : 1小时
            if !secondIsVisible && dateComponent.second! / 59 == 1 {    // 1分钟, 播放一次
                playSound(isEnableSound)
                print("1分钟播放一次 。。。。")
            }
            
            if secondIsVisible {    // 每秒播放一次
                playSound(isEnableSound)
                print("每秒播放一次 。。。。")
            }
            
            weekdayLabel.text = getWeekdayWithNumber(dateComponent.weekday!)
            getYearMonthDay(year: dateComponent.year!, month: dateComponent.month!, day: dateComponent.day!)
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
            weekdayLabel.isHidden = !weekdayIsVisible
        }
    }
    
    /// 年月日是否可见
    var yearMonthDayIsVisible: Bool = false {
        didSet {
            yearToDateLabel.isHidden = !yearMonthDayIsVisible
        }
    }
    
    /// 启用声音 (默认： TRUE)
    var isEnableSound: Bool = true {
        didSet {
            playSound(isEnableSound)
        }
    }
    
    /// 秒是否可见
    var secondIsVisible: Bool = false {
        didSet {
            print("secondIsVisible: \(secondIsVisible)")
            secondItem.isHidden = !secondIsVisible
            bottomToolbarView.clockSecondSwitch.secondSwitch.setOn(secondIsVisible, animated: false)
            font = UIFont(name: "HelveticaNeue-CondensedBold", size: secondIsVisible ? 200 : 280)
            
            // 本地存储 secondIsVisible
            UserDefaults.standard.setValue(secondIsVisible, forKey: "SecondIsVisible")
            UserDefaults.standard.synchronize()
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
    
    /// 主题（默认：暗黑模式）
    var flipClockTheme: ThemeType = .darkTheme {
        didSet {
            ThemeManager.switcherTheme(type: flipClockTheme)
            changeTheme()
            
            if flipClockTheme != oldValue {
                bottomToolbarView.themeSwitchButton.setImage(UIImage(systemName: "sun.min.fill"), for: .normal)
            }else {
                bottomToolbarView.themeSwitchButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
            }
        }
    }
    
    /// 底部工具栏是否可以见（默认：FALSE）
    var bottomToolbarIsVisible: Bool = false
    
    // MARK: Lazy loading
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
        let timeSystemLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 215, height: 30))
        timeSystemLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        timeSystemLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        timeSystemLabel.backgroundColor = .clear
        return timeSystemLabel
    }()
    
    /// 工作日label
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 215, height: 30))
        label.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        label.isHidden = true   // 默认为：隐藏
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 年月日label
    private lazy var yearToDateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 215, height: 30))
        label.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        label.isHidden = true   // 默认为：隐藏
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 底部工具栏视图
    private lazy var bottomToolbarView: BottomToolbarView = {
        let view = BottomToolbarView(frame: CGRect(x: 50, y: bounds.maxY, width: bounds.width - 100, height: 80))
        view.layer.cornerRadius = 8
        view.backgroundColor = ThemeManager.sharedInstance.currentTheme.toolbarBackgroudColor
        view.themeSwitchButton.addTarget(self, action: #selector(themeChangedAction(_:)), for: .touchUpInside)
        view.silentButton.addTarget(self, action: #selector(enableSound(_:)), for: .touchUpInside)
        view.clockSecondSwitch.secondSwitch.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        view.settingsButton.addTarget(self, action: #selector(settingAction(_:)), for: .touchUpInside)
        return view
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
    
    /* 布局尺寸必须在 layoutSubViews 中, 否则获取的 size 不正确 **/
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 间距
        var margin: CGFloat = 0.07 * bounds.size.width
        /// 每个item的宽度
        var itemW: CGFloat = (bounds.size.width - 4 * margin) / 3
        // 设置秒不可见时，间距、宽度
        if !secondIsVisible {
            margin = 0.12 * bounds.size.width
            itemW = CGFloat(bounds.size.width - 3 * margin) / 2
        }
        /// 每个item的Y值
        let itemY: CGFloat = (bounds.size.height - itemW) / 2
/*
        UIView.animate(withDuration: 0.25) {
            self.hourItem.frame = CGRect(x: margin, y: itemY, width: itemW, height: itemW)
            self.minuteItem.frame = CGRect(x: self.hourItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
            self.secondItem.frame = CGRect(x: self.minuteItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
        } completion: { (finish) in
            print("布局完成。。。")
        }
*/
        hourItem.frame = CGRect(x: margin, y: itemY, width: itemW, height: itemW)
        minuteItem.frame = CGRect(x: hourItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
        secondItem.frame = CGRect(x: minuteItem.frame.maxX + margin, y: itemY, width: itemW, height: itemW)
    }
    
    /* 告诉视图其窗口对象即将更改。**/
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            // 移除通知
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}

// MARK: - Configuration
extension FlipClockView {
    
    private func configUI() {
        configGestureRecognizer()
        
        // 取出本地存储值
        secondIsVisible = UserDefaults.standard.bool(forKey: "SecondIsVisible")
        
        // 默认主题背景色
        backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroudColor
        
        // 修改窗口及其所有子视图, 用户界面样式.（默认暗黑模式）
        appDelegate.window?.overrideUserInterfaceStyle = .dark
        
        addSubview(hourItem)
        addSubview(minuteItem)
        addSubview(secondItem)
        hourItem.addSubview(timeSystemLabel)
        minuteItem.addSubview(weekdayLabel)
        secondItem.addSubview(yearToDateLabel)
        addSubview(bottomToolbarView)
    }
    
    private func configGestureRecognizer() {
        // 点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1      // 单击
        //tap.numberOfTapsRequired = 2    // 双击
        addGestureRecognizer(tap)
        
        /// 平移手势
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(_:)))
        panGesture.minimumNumberOfTouches = 1   // 最小手指数: 单指滑动
        addGestureRecognizer(panGesture)
    }
}

// MARK: - Convert Time Format
extension FlipClockView {
    
    /// 转换时间制式 （24 - > 12小时制）
    ///
    /// - Returns: String
    private func convertTimeFormat() -> String {
        let df = DateFormatter()
        
        // 跟踪用户当前偏好的语言环境。自动更新的语言环境
        df.locale = Locale.autoupdatingCurrent
        
        // 设置时间格式
        /*
         “a”:是AM / PM指示符的ICU符号。
         它永远不可能是“ A”，因为ICU使用“A”:来表示完全不同的东西（一天中的毫秒数）。
         */
        
        df.dateFormat = "a"
        
        //df.amSymbol = "AM"
        //df.pmSymbol = "PM"
        // 指定时区
        // df.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        //设置时区: 系统当前使用的时区
        df.timeZone = TimeZone.current
        
        print("当前时区-\(TimeZone.current)----\(NSTimeZone.system)")
        
        // 调用string方法进行转换
        let dateString = df.string(from: Date())
        print(dateString)   // "PM\AM"
        return dateString
    }
    
    /// 根据数字获取工作日
    /// - Parameter number: 数字
    private func getWeekdayWithNumber(_ number: Int) -> String? {
        switch number {     // 使用本地化字符串
        case 1:
            return NSLocalizedString("Sun", comment: "")
        case 2:
            return NSLocalizedString("Mon", comment: "")
        case 3:
            return NSLocalizedString("Tues", comment: "")
        case 4:
            return NSLocalizedString("Wed", comment: "")
        case 5:
            return NSLocalizedString("Thur", comment: "")
        case 6:
            return NSLocalizedString("Fri", comment: "")
        case 7:
            return NSLocalizedString("Sat", comment: "")
        default:
            return ""
        }
    }
    
    /// 获取年月日 （ 区分语言环境 ）
    private func getYearMonthDay(year: Int, month: Int, day: Int) {
        /*
         1）英式的日期：日/月/年；Day/Month/Year
         2）美式的日期：月/日/年；Month/Day/Year
         */
        
        /// 首选语言：捆绑软件中包含的首选本地化的有序列表第一个
        let preferredLang = Bundle.main.preferredLocalizations.first!
        //print("当前系统语言:\(preferredLang)")
        
        switch preferredLang {
        case "en-US", "en-CN":  // 英文
            yearToDateLabel.text = "\(month) / \(day) / \(year)"
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":  // 中文
            yearToDateLabel.text = "\(year)年\(month)月\(day)日"
        default:
            yearToDateLabel.text = "\(month) / \(day) / \(year)"  // 默认英文
        }
    }
    
}

// MARK: - Theme Handle
extension FlipClockView {
    
    /// 修改主题
    func changeTheme() {
        // 添加通知监听主题切换
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)),
                                               name: ThemeNotifacationName,
                                               object: nil)
        ThemeManager.themeUpdate()
    }
    
    /// 处理通知
    @objc private func handleNotification(notification: NSNotification) {
        /// 当前主题
        guard let theme = notification.object as? ThemeProtocol else { return }
        
        /* 修改对应元素的颜色 **/
/*
        backgroundColor = theme.backgroudColor
        soundsButton.tintColor = theme.tintColor
        soundsButton.backgroundColor = theme.labelBackgroudColor
        themeSwitchButton.tintColor = theme.tintColor
        themeSwitchButton.backgroundColor = theme.labelBackgroudColor
        
        timeSystemLabel.textColor = theme.textColor
        weekdayLabel.textColor = theme.textColor
        yearToDateLabel.textColor = theme.textColor
*/
        backgroundColor = themeBackgroundColor(theme: theme)
        
        timeSystemLabel.textColor = themeTextColor(theme: theme)
        weekdayLabel.textColor = themeTextColor(theme: theme)
        yearToDateLabel.textColor = themeTextColor(theme: theme)
        
        hourItem.updateLabelThemeColor(theme)
        minuteItem.updateLabelThemeColor(theme)
        secondItem.updateLabelThemeColor(theme)
        
        bottomToolbarView.backgroundColor = themeToolbarBackgroundColor(theme: theme)
        bottomToolbarView.silentButton.tintColor = themeTintColor(theme: theme)
        bottomToolbarView.silentButton.backgroundColor = themeLabelBackgroundColor(theme: theme)
        bottomToolbarView.themeSwitchButton.tintColor = themeTintColor(theme: theme)
        bottomToolbarView.themeSwitchButton.backgroundColor = themeLabelBackgroundColor(theme: theme)
        bottomToolbarView.settingsButton.tintColor = themeTintColor(theme: theme)
        bottomToolbarView.settingsButton.backgroundColor = themeLabelBackgroundColor(theme: theme)
        bottomToolbarView.clockSecondSwitch.secLabel.textColor = themeTextColor(theme: theme)
        bottomToolbarView.clockSecondSwitch.secondSwitch.onTintColor = themeLabelBackgroundColor(theme: theme)
        bottomToolbarView.clockSecondSwitch.secondSwitch.thumbTintColor = themeTintColor(theme: theme)
    }
    
    /* ------------- 可选 （ Optional..... ） --------------- **/
    /// 主题色调颜色
    func themeTintColor(theme: ThemeProtocol) -> UIColor {
        return theme.tintColor
    }
    
    /// 主题文字颜色
    func themeTextColor(theme: ThemeProtocol) -> UIColor {
        return theme.textColor
    }
    
    /// 主题背景颜色
    func themeBackgroundColor(theme: ThemeProtocol) -> UIColor {
        return theme.backgroudColor
    }
    
    /// 主题Label背景颜色
    func themeLabelBackgroundColor(theme: ThemeProtocol) -> UIColor {
        return theme.labelBackgroudColor
    }
    
    /// 主题工具栏背景颜色
    func themeToolbarBackgroundColor(theme: ThemeProtocol) -> UIColor {
        return theme.toolbarBackgroudColor
    }
    
}

// MARK: - Actions
extension FlipClockView {
    
    /// 处理点击
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        /// 点击时, 相对于 `bottomToolbarView` 的位置
        let tapPoint = tap.location(in: bottomToolbarView)
        
        // 如果当前手势点击，不位于底部工具栏视图时，隐藏, 否显示。
        if bottomToolbarIsVisible && !bottomToolbarView.layer.contains(tapPoint) {
            hiddenBottomToolbarView()
        }else {
            showBottomToolbarView()
        }
    }
    
    /// 处理滑动（改变  `屏幕亮度` ）
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        /// 获取当前屏幕的亮度
        var brightness: Float = Float(UIScreen.main.brightness)
        
        if recognizer.state == .changed || recognizer.state == .ended {
            /// 滑动速度
            let velocity: CGPoint = recognizer.velocity(in: self)
            
            if velocity.y > 0 {     // Y：上、下滑动
                brightness -= 0.01  // 降低亮度
                print("降低亮度 in pan  \(brightness)")
                // 设置屏幕的亮度级别
                UIScreen.main.brightness = CGFloat(brightness)
            }else {
                brightness += 0.01  // 增加亮度
                print("增加亮度 in pan \(brightness)")
                // 设置屏幕的亮度级别
                UIScreen.main.brightness = CGFloat(brightness)
            }
            print("当前设置后的屏幕亮度： \(UIScreen.main.brightness)")
        }
    }
    
    /// 主题修改操作
    @objc private func themeChangedAction(_ sender: UIButton) {
        /// 是否处于选定状态,  默认为 FALSE
        let isSelected = sender.isSelected
        
        //print(isSelected ? "暗黑模式" : "浅色模式")
        
        // 1.切换主题
        if isSelected {
            // 修改窗口及其所有子视图, 用户界面样式.
            appDelegate.window?.overrideUserInterfaceStyle = .dark
            ThemeManager.switcherTheme(type: .darkTheme)
            sender.setImage(UIImage(systemName: "moon.fill"), for: .normal)
            print("暗黑模式")
            print(isSelected)
        }else {
            // 修改窗口及其所有子视图, 用户界面样式.
            appDelegate.window?.overrideUserInterfaceStyle = .light
            ThemeManager.switcherTheme(type: .lightTheme)
            sender.setImage(UIImage(systemName: "sun.min.fill"), for: .normal)
            print("浅色模式")
            print(isSelected)
        }
                
        // 2.本地存储
        let defaults = UserDefaults.standard
        defaults.setValue(isSelected, forKey: "CurrentTheme")
        defaults.setValue(isSelected, forKey: "DisplayMode")
        defaults.synchronize()
        
        // 3.修改元素色彩
        changeTheme()
        
        // 4.切换按钮状态
        sender.isSelected = !sender.isSelected
    }
    
    /// 开启声音
    @objc private func enableSound(_ sender: UIButton) {
        /// 按钮的选定状态, 默认为 FALSE
        let isSelected = sender.isSelected
        if isSelected {
            isEnableSound = true
        } else {
            isEnableSound = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    /// 是否播放声音
    @objc private func playSound(_ enable: Bool) {
        
        /// SystemSoundID:  用您要播放的声音文件标识的系统声音对象
        // 声明一个声音源ID，与声音文件相对应
        var soundId: SystemSoundID = 1
        
        /// 获取本地存储的 秒音效名称
        let secTone = UserDefaults.standard.string(forKey: "SecToneName")
        
        /// 获取沙箱目录中文件所在的路径， waw等格式 。默认：flip音效
        guard let path = Bundle.main.path(forResource: secTone != nil ? secTone : "flip", ofType: "wav") else { return }
        
        /// 要播放的音频文件的URL
        let FileURL = URL(fileURLWithPath: path)
        
        // 创建系统声音对象。
        AudioServicesCreateSystemSoundID(FileURL as CFURL, &soundId)
        
        if enable {
            // 播放声音
            AudioServicesPlaySystemSound(soundId)
        }else {
            // 不使用声音的时候，需要释放掉声音资源
            AudioServicesDisposeSystemSoundID(soundId)
        }
    }
    
    /// 秒开关已更改
    @objc private func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {            // 开
            secondIsVisible = true
            /* 使用setNeesLayout()标记: 需要重新布局, 它会调用layoutSubviews */
            setNeedsLayout()
        }else {                 // 关
            secondIsVisible = false
            /* 使用setNeesLayout()标记: 需要重新布局, 它会调用layoutSubviews */
            setNeedsLayout()
        }
    }
    
    /// 设置按钮操作
    @objc private func settingAction(_ sender: UIButton) {
        let rootVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
        let storyboard = UIStoryboard(name: "SettingController", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let settingController = storyboard.viewControllers.first as! SettingController
        rootVC.pushViewController(settingController, animated: true)
    }
    
    private func showBottomToolbarView() {
        UIView.animate(withDuration: 0.25) {        // 显示
            self.bottomToolbarView.transform = CGAffineTransform(translationX: 0, y: -80)
        } completion: { (finish) in
            print("弹出完成。。。。")
            self.bottomToolbarIsVisible = true
        }
    }
    
    private func hiddenBottomToolbarView() {
        UIView.animate(withDuration: 0.25) {
            self.bottomToolbarView.transform = .identity    // 隐藏
        } completion: { (finish) in
            print("隐藏完成。。。。")
            self.bottomToolbarIsVisible = false
        }
    }
    
}

// MARK: - Removes user defaults
extension FlipClockView {
    
    /**
     *  清除所有的存储本地的数据
     */
    func clearAllUserDefaultsData() {
        guard let identifier = Bundle.main.bundleIdentifier else { return }
        // 删除存储对象: 通过 removeObject() 方法可以删除已保存的数据。当然如果这个存储对象不存在也不会报错。
        UserDefaults.standard.removePersistentDomain(forName: identifier)
    }
}
