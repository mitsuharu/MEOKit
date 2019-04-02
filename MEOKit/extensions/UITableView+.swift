//
//  UITableView+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/05.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UITableView {
    
    /// cellを登録する（クラス名とnibファイル名は同一と想定する）
    ///
    /// - Parameter className: クラス名
    func registerCell(className: String) {
        let nib = UINib(nibName: className, bundle: Bundle.main)
        self.base.register(nib, forCellReuseIdentifier: className)
    }
    
    /// data source に指定した indexPath があるか判定する
    ///
    /// - Parameter indexPath: インデックスパス
    /// - Returns: data source にあればtrue，そうでなければfalse
    func hasIndexPath(_ indexPath: IndexPath) -> Bool {
        let sections = self.base.numberOfSections
        let rows = self.base.numberOfRows(inSection: indexPath.section)
        return (indexPath.section < sections) && (indexPath.row < rows)
    }
    
}

extension UITableView{
}
