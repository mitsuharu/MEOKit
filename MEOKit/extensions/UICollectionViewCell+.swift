//
//  UICollectionViewCell+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/01/14.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UICollectionViewCell {
    
    /// 自身をaddしたUICollectionViewを取得する
    var collectionView: UICollectionView? {
        return self.base.parent(type: UICollectionView.self)
    }
    
    /// 自身のIndexPathを取得する
    var indexPath: IndexPath? {
        guard let cv: UICollectionView = self.collectionView else {
            return nil
        }
        return cv.indexPath(for: self.base)
    }
    
    /// 自身を reloadItems() する
    ///
    /// - Returns: 成功したらtrue（例外はキャッチできない）．
    @discardableResult
    func reload() -> Bool{
        guard
            let cv: UICollectionView = self.collectionView,
            let ip = cv.indexPath(for: self.base) else {
                return false
        }
        var result: Bool = false
        let sections: Int = cv.numberOfSections
        let rows: Int = cv.numberOfItems(inSection: sections)
        let hasIndexPath: Bool = (ip.section < sections) && (ip.row < rows)
        if cv.indexPathsForVisibleItems.contains(ip) && hasIndexPath{
            cv.reloadItems(at: [ip])
            result = true
        }
        return result
    }
    
}
