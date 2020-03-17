//
//  ViewController.swift
//  FlipClock
//
//  Created by Liu Chuan on 2018/5/28.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 时钟视图
    private lazy var flipClock: FlipClockView = {
        let flip = FlipClockView(frame: self.view.bounds)
        flip.backgroundColor = .black
        flip.is12HourClock = true
        flip.secondIsVisible = true
        flip.weekdayIsVisible = true
        flip.yearMonthDayIsVisible = true
        flip.date = Date()
        return flip
    }()
    
    /// 定时器
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(flipClock)
        
        // 创建Timer对象
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
   
    /** 状态栏风格 **/
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     portrait   : 竖屏, 肖像
     landscape  : 横屏, 风景画
     
     - 使用代码控制设备的方向. 优点: 可以在需要的时候, 单独处理
     - 设置设备支持方向后,当前控制器 以及 字控制器 都会遵守设置的方向
     - 如果播放视频, 通常是通过 modal 展现的!
     */
    
    // MARK: - 设备的支持方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

//MARK: - Handle Event
extension ViewController {
    /// 定时器的监听事件
    @objc private func updateTimeLabel() {
        let timeDate = Date()
        flipClock.date = timeDate
    }
}
