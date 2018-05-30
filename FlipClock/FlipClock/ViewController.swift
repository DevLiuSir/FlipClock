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
        flip.backgroundColor = .white
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
    
    /// 定时器的监听事件
    @objc private func updateTimeLabel() {
        let timeDate = Date()
        flipClock.date = timeDate
    }
}
