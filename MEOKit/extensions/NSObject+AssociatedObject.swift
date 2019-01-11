//
//  NSObject+AssociatedObject.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/01/12.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

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
    public func associate(obj: Any?, forKey key: String) {
        
        var associatedObj:AssociatedObj = AssociatedObj()
        if let temp = self._associatedObject(){
            associatedObj = temp
        }
        associatedObj.dict[key] = obj
        
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
            return temp.dict[key]
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
        self.associate(obj: nil, forKey: key)
    }
    
}
