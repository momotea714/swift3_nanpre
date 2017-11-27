//
//  URLSr.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/23.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation

struct URLString{
    static let SelectIndexListURL = "https://nanpre.gear.host/Momoes/IndexAPI"
    //gearhostが止まっている時用
//    static let SelectIndexListURL = "https://swift-todo-api-mmtr.c9users.io/get_momoindex"
    static let _SelectQuestionURL = "https://nanpre.gear.host/Home/IndexAPI/"
    static let SignalRURL = "https://nanpre.gear.host"
    
    static func SelectQuestionURL(momo_id:Int) -> String {
        return _SelectQuestionURL + String(momo_id)
    }
}
