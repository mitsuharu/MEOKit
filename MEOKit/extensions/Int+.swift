//
//  Int+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/04/02.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T == Int {
    
    /// コンマ区切りの文字列に変換する
    var commaSeparated: String{
        let num = NSNumber(value: self.base)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: num)!
    }

}

