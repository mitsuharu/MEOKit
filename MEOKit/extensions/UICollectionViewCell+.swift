//
//  UICollectionViewCell+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/01/14.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UICollectionViewCell {
    
    /// 自身をaddしたUITableViewを取得する
    public var collectionView: UICollectionView? {
        return self.base.parent(type: UICollectionView.self)
    }
    
    /// 自身のIndexPathを取得する
    public var indexPath: IndexPath? {
        guard let cv: UICollectionView = self.collectionView else {
            return nil
        }
        return cv.indexPath(for: self.base)
    }
    
    /// 自身を reloadItems() する
    ///
    /// - Returns: 成功したらtrue（例外はキャッチできない）．
    @discardableResult
    public func reload() -> Bool{
        guard
            let collectionView: UICollectionView = self.collectionView,
            let ip = collectionView.indexPath(for: self.base) else {
                return false
        }
        var result: Bool = false
        let ips = collectionView.indexPathsForVisibleItems
        if ips.contains(ip){
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [ip])
            }
            result = true
        }
        return result
    }
    
}
