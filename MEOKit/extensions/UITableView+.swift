//
//  UITableView+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/05.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UITableView{
    
    /// cellを登録する（クラス名とnibファイル名は同一と想定する）
    public func registerCell(className: String) {
        let nib = UINib(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: className)
    }
}
