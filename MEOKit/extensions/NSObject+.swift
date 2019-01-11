//
//  NSObject+.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import ObjectiveC

public extension MeoExtension where T: NSObject {
    
    /// クラス名を取得する
    public var className: String {
        get {
            var name = String(describing: type(of: self.base))
            if let range = name.range(of: ".Type") {
                name.replaceSubrange(range, with: "")
            }
            return name
        }
    }
    
    /// クラスの変数などを文字列で出力する
    public var classDescription : String {
        let mirror = Mirror(reflecting: self.base)
        let arr = mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
        }
        var str = "none"
        if arr.count > 0{
            str = arr.joined(separator: "\n")
        }
        return str
    }
}

