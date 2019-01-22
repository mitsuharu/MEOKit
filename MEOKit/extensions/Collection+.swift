//
//  Collection+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/05.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension Collection {
    
    /// 配列範囲を考慮して値を取得する．
    ///
    /// - Parameter index: 配列要素番号
    public subscript(safe index: Index) -> Element? {
        if startIndex <= index && index < endIndex{
            return self[index]
        }
        return nil
    }
}
