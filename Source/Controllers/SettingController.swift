//
//  SettingController.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    
/*
    /* 视图控制器其视图, 即将移除时，调用。**/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 页面退出时还原强制横屏状态
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }

    /* 视图控制器其视图, 即将添加时，调用。**/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 该页面显示时强制竖屏显示
//        appDelegate.interfaceOrientations = .portrait
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 标识选定行的行、组的索引路径。
        guard let index = tableView.indexPathForSelectedRow else { return }
        print("当前点击了第： \(index.section) 组")
        print("当前点击了第：\(index.row) 行")
        
        if index.section == 1 && index.row == 0 {   // Github
            
            // 使用Safari，打开github链接
            UIApplication.shared.open(URL(string: AppData.githubLink)!, options: [:], completionHandler: nil)
            
        }else if index.section == 1 && index.row == 1 {     // Twitter
            
            // 使用Safari，打开twitter链接
            UIApplication.shared.open(URL(string: AppData.twitterLink)!, options: [:], completionHandler: nil)
            
        }else if index.section == 1 && index.row == 2 {     // 邮件反馈
            
            // mailto：系统自带邮件，打开邮箱。
            UIApplication.shared.open(URL(string: "mailto:\(AppData.authorMail)")!, options: [:], completionHandler: nil)
        }
    }
    
}

// MARK: - Configure
extension SettingController {
    
    private func configUI() {
        configNavigationBar()
    }
    
    private func configNavigationBar() {
        // 设置导航栏元素颜色
        navigationController?.navigationBar.tintColor = .label
    }
}
