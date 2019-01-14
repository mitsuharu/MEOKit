//
//  NSObject+ObjC.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/01/12.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import ObjectiveC

// 連想オブジェのキー
fileprivate var AssociatedKey = 0

// 連想オブジェで保存するクラス
fileprivate class AssociatedObj: NSObject, NSCopying{
    
    func copy(with zone: NSZone? = nil) -> Any {
        let temp = AssociatedObj()
        temp.dict = self.dict
        return temp
    }
    
    var dict: [String:Any] = [String:Any]()
}

public extension MeoExtension where T: NSObject {
    
    // 読み込み
    fileprivate func _associatedObject() -> AssociatedObj? {
        let obj = objc_getAssociatedObject(self.base, &AssociatedKey)
        if let associatedObj = obj as? AssociatedObj{
            return associatedObj
        }
        return nil
    }
    
    /// インスタンスにオブジェクトを記録する
    ///
    /// - Parameters:
    ///   - obj: オブジェクト
    ///   - key: キー
    public func associate(obj: Any?, key: String) {
        
        var associatedObj:AssociatedObj = AssociatedObj()
        if let temp = self._associatedObject(){
            associatedObj = temp
        }
        associatedObj.dict[self.base.uniquekey(key)] = obj
        
        objc_setAssociatedObject(self.base,
                                 &AssociatedKey,
                                 associatedObj,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    /// 連想記録したオブジェクトを取得する
    ///
    /// - Parameters:
    ///   - key: キー
    /// - Returns: オブジェクト（Any型）
    public func associated(key: String) -> Any? {
        if let temp = self._associatedObject(){
            return temp.dict[self.base.uniquekey(key)]
        }
        return nil
    }
    
    /// 連想記録したオブジェクトを取得する
    ///
    /// - Parameters:
    ///   - key: キー
    ///   - type: 返り値の型を指定する(String.self など）
    /// - Returns: オブジェクト
    public func associated<T:Any>(key: String, type: T.Type) -> T? {
        if let obj = self.associated(key: key){
            return (obj as? T) ?? nil
        }
        return nil
    }
    
    /// 保存したオブジェクトの削除
    ///
    /// - Parameter key: キー
    public func removeAssociated(key: String)  {
        self.associate(obj: nil, key: key)
    }
    
}

public extension MeoExtension where T: NSObject {
    
    /// メソッドの入れ替え（メソッド名に from/to を用いているが入れ替え，両方向に影響する）
    ///
    /// 実行例
    /// ```
    /// self.meo.swizzle(from: #selector(test01), to: #selector(test02))
    /// ```
    ///
    /// 入れ替えるメソッドには ```@objc dynamic``` を付ける
    /// ```
    /// @objc dynamic func test01() {
    ///     print("test01")
    /// }
    /// ```
    ///
    /// 既存メソッドを入れ替える場合は一般に関数で自身を呼ぶ．ループのように見えるが，このときメソッド中の関数は入れ替えた関数になる．つまり既存メソッドを実行してから機能追加を行うことができる．
    /// ```
    /// @objc dynamic func viewDidAppear2(_ animated: Bool) {
    ///     viewDidAppear2(animated)
    ///     print("viewDidAppear2")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - fromMethod: 入れ替えるメソッドのセレクター ```#selector(viewDidAppear(_:))```
    ///   - toMethod: 入れ替えるメソッドのセレクター ```#selector(viewDidAppear2(_:))```
    ///   - anyClass: そのメソッドを持つクラス（デフォルトnilで自動設定する）．```self.classForCoder``` や ```UIView.self ``` など
    ///
    public func swizzle(from fromMethod: Selector,
                        to toMethod: Selector,
                        anyClass: AnyClass? = nil){
        var cls:AnyClass = self.base.classForCoder
        if let temp = anyClass{
            cls = temp
        }
        guard
            let to: Method = class_getInstanceMethod(cls, toMethod),
            let from: Method = class_getInstanceMethod(cls, fromMethod)
        else {
            return
        }
        method_exchangeImplementations(from, to)
    }
}
