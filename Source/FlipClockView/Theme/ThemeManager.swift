//
//  ThemeManager.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

let ThemeNotifacationName = NSNotification.Name("keyThemeNotifacation")

class ThemeManager: NSObject {
    
    /// 当前使用的主题（默认：DarkTheme）
    var currentTheme: ThemeProtocol = DarkTheme()
    
    /// 单例
    static var sharedInstance = ThemeManager()
    
    // MARK: - 便利方法
    /// 切换主题的便利方法
    ///
    /// - Parameter type: 需要切换的主题类型
    static func switcherTheme(type: ThemeType) {
        ThemeManager.sharedInstance.switcherTheme(type: type)
    }
    
    /// 更新主题的便利方法
    static func themeUpdate() {
        // 发送通知
        NotificationCenter.default.post(name: ThemeNotifacationName, object: ThemeManager.sharedInstance.currentTheme)
    }

    //MARK: - Private Method
    
    /// ThemeManager的私有构造器
    private override init() {
        
    }
    
    /// 切换主题的方法
    ///
    /// - Parameter type: 要切换主题的枚举类型
    private func switcherTheme(type: ThemeType){
        self.currentTheme = type.theme
        NotificationCenter.default.post(name: ThemeNotifacationName, object: self.currentTheme)
    }
}
