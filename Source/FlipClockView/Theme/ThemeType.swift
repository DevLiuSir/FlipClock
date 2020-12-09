//
//  ThemeType.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

/// 主题类型
enum ThemeType {
    case lightTheme
    case darkTheme
    
    /// 主题类型所对应的主题对象
    var theme: ThemeProtocol {
        get {
            switch self {
            case .lightTheme:
                return LightTheme()
            case .darkTheme:
                return DarkTheme()
            }
        }
    }
}
