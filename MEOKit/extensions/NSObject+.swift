//
//  NSObject+.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: NSObject {
    
    /// クラス名を取得する
    var className: String {
        get {
            var name = String(describing: type(of: self.base))
            if let range = name.range(of: ".Type") {
                name.replaceSubrange(range, with: "")
            }
            return name
        }
    }
    
    /// クラスの変数などを文字列で出力する
    var classDescription: String {
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

// 一度だけ行う処理を管理する
private var onceKeys = [String]()

public extension MeoExtension where T: NSObject {
    
    /// once処理を再び行いたい場合のクリア
    func clearOnceKeys(){
        onceKeys.removeAll()
    }
    
    /// once処理を行ったのか確認
    func isOnced(key: String) -> Bool{
        return onceKeys.contains(self.base.uniquekey(key))
    }
    
    /// 一度だけ有効な処理を行う
    ///
    /// - Parameters:
    ///   - key: キー
    ///   - block: 行いたい処理
    func once(key: String, block:()->()){
        // 排他制御を有効にする
        objc_sync_enter(self.base)
        defer {
            objc_sync_exit(self.base)
        }
        if onceKeys.contains(self.base.uniquekey(key)) {
            return
        }
        onceKeys.append(self.base.uniquekey(key))
        block()
    }
}

extension NSObject{
    
    /// キー保存が外部変数なので，異なるインスタンスでの衝突を防ぐためメモリアドレスを接頭語にする
    func uniquekey(_ key: String) -> String{
        let str:String = Unmanaged.passUnretained(self).toOpaque().debugDescription
        return str + "." + key
    }
}

