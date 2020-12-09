//
//  SecToneTableVC.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

class SecToneTableVC: UITableViewController {
    
    /* 视图控制器其视图, 即将移除时，调用。**/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /* 视图控制器其视图, 即将添加时，调用。**/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
  
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1.获取cell标签的文本
        /// 当前选择的Cell
        let currentSelectedCell = tableView.cellForRow(at: indexPath)! as! SecToneTableViewCell
        
        /// 获取cell的label
        let label = currentSelectedCell.contentView.subviews.first as! UILabel
        guard let songName = label.text else { return }
        print(indexPath.row)
        print("选择的音效：\(songName)")
        
        // 2.截取后，得到新的字符串
        /// 得到 " -" 在字符串中的位置
        let index = songName.firstIndex(of: "-")
        /// index位置往后移动 1 位
        let newIndex = songName.index(index!, offsetBy: 1)
        
        // 获取"-"后的所有字符（不包括包括"-")
        let secToneName = songName[newIndex...].description
        print("截取后的音效名称: \(secToneName)")
        
        // 3.播放
        SoundManager.sharedInstance.playSecTone(forResource: secToneName, ofType: "wav")
        
        // 4.本地存储
        UserDefaults.standard.setValue(secToneName, forKey: "SecToneName")
        UserDefaults.standard.synchronize()
        
    }
    
}
