//
//  Extension.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/05.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public class MyExtension<T> {
    let base: T
    init (_ base: T) {
        self.base = base
    }
}

public protocol MyExtensionProtocol {
    associatedtype T
    var meo: MyExtension<T> { get }
}

public extension MyExtensionProtocol {
    public var meo: MyExtension<Self> {
        return MyExtension(self)
    }
}

// すべてに meo を作成する
// プロトコル型とクラス型以外のものを指定するとエラーになる（Stringなど）
extension NSObject : MyExtensionProtocol{}

// hogehoge.meo.foo() で追加できる
public extension MyExtension where T: NSObject {
}
