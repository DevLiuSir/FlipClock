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
        flip.flipClockTheme = .darkTheme
        flip.is12HourClock = true
        flip.secondIsVisible = true
        flip.weekdayIsVisible = true
        flip.yearMonthDayIsVisible = true
        flip.date = Date()
        return flip
    }()
    
    /// 定时器
    var timer: Timer?
    
    /* 视图控制器其视图, 即将消失、被覆盖、隐藏时，调用。**/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    /* 视图控制器其视图, 即将加入窗口时，调用。**/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getUserDefaultsPlistURL()
        view.addSubview(flipClock)
        
        // 创建Timer对象
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    private func getUserDefaultsPlistURL() {
        let fileName = Bundle.main.bundleIdentifier!
        let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let preferences = library.appendingPathComponent("Preferences")
        let userDefaultsPlistURL = preferences.appendingPathComponent(fileName).appendingPathExtension("plist")
        print("Library directory:", userDefaultsPlistURL.path)
        print("Preferences directory:", userDefaultsPlistURL.path)
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
