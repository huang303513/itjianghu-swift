//
//  Common.swift
//  itjh
//
//  Created by aiteyuan on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import Foundation
import UIKit

let screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
let screenHeight:CGFloat = UIScreen.mainScreen().bounds.height
let color = UIColor(hue: 10, saturation: 20, brightness: 10, alpha: 1)
let jishuCellHeight:CGFloat = 80
let shareUrl = "http://www.itjh.com.cn/"

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)
}
