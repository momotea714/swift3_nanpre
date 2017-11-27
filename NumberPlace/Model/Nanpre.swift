//
//  Nanpre.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/23.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation
import Unbox

struct Nanpre: Unboxable {
    var question: String
    
    static let _idParamString = "task_id"
    
    init(unboxer: Unboxer) throws {
        self.question = try unboxer.unbox(key: "question")
    }
    init() {
        self.question = ""
    }
    
    static func getSelectQueryItems(nanpre_id: Int) -> ([URLQueryItem]){
        return [URLQueryItem(name: _idParamString, value: String(nanpre_id))]
    }
    
}
