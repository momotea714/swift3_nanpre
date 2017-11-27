//
//  Momo.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/23.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation
import Unbox
struct Momo {
    var id: Int
    var NanpreNO: Int
    var MakeUserID: String
    var IsPublic: Bool
    var Title: String
    var Remarks: String
    var IsCleared: Bool
    
        init() {
            self.id = -1
            self.NanpreNO = -1
            self.MakeUserID = ""
            self.IsPublic = false
            self.Title = ""
            self.Remarks = ""
            self.IsCleared = false
    //        self.CreatedDateTime = ""
        }
}
//struct Momo: Unboxable {
//    var id: Int
//    var NanpreNO: Int
//    var MakeUserID: String
//    var IsPublic: Bool
//    var Title: String
//    var Remarks: String
//    var IsCleared: Bool
////    var CreatedDateTime: NSDate?
////    static let _idParamString = "task_id"
////    static let _nameParamString = "task_name"
////    static let _categoryParamString = "task_category"
//
//    init(unboxer: Unboxer) throws {
//        self.id = try unboxer.unbox(key: "ID")
//        self.NanpreNO = try unboxer.unbox(key: "NanpreNO")
//        self.MakeUserID = try unboxer.unbox(key: "MakeUserID")
//        self.IsPublic = try unboxer.unbox(key: "IsPublic")
//        self.Title = try unboxer.unbox(key: "Title")
//        self.Remarks = try unboxer.unbox(key: "Remarks")
//        self.IsCleared = try unboxer.unbox(key: "IsCleared")
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "YYYY-MM-dd"
////        self.CreatedDateTime = try unboxer.unbox(key: "CreatedDateTime", formatter: dateFormatter)
//    }
//    init() {
//        self.id = -1
//        self.NanpreNO = -1
//        self.MakeUserID = ""
//        self.IsPublic = false
//        self.Title = ""
//        self.Remarks = ""
//        self.IsCleared = false
////        self.CreatedDateTime = ""
//    }
//
//    static func getDeleteQueryItems(task_id: Int) -> ([URLQueryItem]){
//        return [URLQueryItem(name: _idParamString, value: String(task_id))]
//    }
//
//    static func getInsertQueryItems( task_name: String, task_category: String) -> ([URLQueryItem]){
//        return [URLQueryItem(name: _nameParamString, value: task_name),
//                URLQueryItem(name: _categoryParamString, value: task_category)]
//    }
//
//    static func getUpdateQueryItems(task_id: Int, task_name: String, task_category: String) -> ([URLQueryItem]){
//        return [URLQueryItem(name: _idParamString, value: String(task_id)),
//                URLQueryItem(name: _nameParamString, value: task_name),
//                URLQueryItem(name: _categoryParamString, value: task_category)]
//    }
//}

