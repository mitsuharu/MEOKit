//
//  Extension.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/05.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/*
 原則，インスタントメソッドの extension は
 hogehoge.meo.foo() のように meo を差し込んで，メソッドの衝突を防ぐ
 */

public class MeoExtension<T> {
    let base: T
    init (_ base: T) {
        self.base = base
    }
}

public protocol MeoExtensionProtocol {
    associatedtype T
    var meo: MeoExtension<T> { get }
}

public extension MeoExtensionProtocol {
    var meo: MeoExtension<Self> {
        return MeoExtension(self)
    }
}

// meo を作成する
extension NSObject : MeoExtensionProtocol{}
extension String : MeoExtensionProtocol{}
extension Int : MeoExtensionProtocol{}

//// hogehoge.meo.foo() で追加できる
//public extension MeoExtension where T: NSObject {
////    func foo() {
////    }
//}
