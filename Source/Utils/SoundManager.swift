//
//  SoundManager.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit
import AudioToolbox

/// 声音管理器
class SoundManager: NSObject {
    
    /// 单例
    static var sharedInstance = SoundManager()
    
    /// 播放秒音效
    /// - Parameters:
    ///   - name: 资源文件名
    ///   - ext: 资源类型
    func playSecTone(forResource name: String?, ofType ext: String?) {
        
        /// SystemSoundID:  用您要播放的声音文件标识的系统声音对象
        // 声明一个声音源ID，与声音文件相对应
        var soundId: SystemSoundID = 1
        
        guard let path = Bundle.main.path(forResource: name, ofType: ext) else { return }
        
        /// 要播放的音频文件的URL
        let FileURL = URL(fileURLWithPath: path)
        
        // 创建系统声音对象。
        AudioServicesCreateSystemSoundID(FileURL as CFURL, &soundId)
        
        // 播放声音
        AudioServicesPlaySystemSound(soundId)
    }
}
