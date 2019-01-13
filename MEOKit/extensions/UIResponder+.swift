//
//  UIResponder+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/01/11.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIResponder {
    
    // 指定した型の親を取得する
    func parent<T: UIResponder>(type: T.Type) -> T? {
        return next as? T ?? next?.parent(type: type)
    }
}
