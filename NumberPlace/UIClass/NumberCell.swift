//
//  NumberCell.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/07.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation
import UIKit

class NumberCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height))
        textLabel.font = UIFont(name: "KohinoorTelugu-Light", size: 25)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.textColor = UIColor.blue
        // Cellに追加
        self.addSubview(textLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}

