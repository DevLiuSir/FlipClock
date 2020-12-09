//
//  ThemeProtocol.swift
//  FlipClock
//
//  Created by Liu Chuan on 2020/12/01.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var textColor: UIColor { get }
    var labelBackgroudColor: UIColor { get }
    var backgroudColor: UIColor { get }
    var tintColor: UIColor { get }
    var lineColor: UIColor { get }
    var toolbarBackgroudColor: UIColor { get }
}
