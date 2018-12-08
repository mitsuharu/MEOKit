//
//  CachedDataManager.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/09.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public class CachedDataManager: NSObject {

    public var shared: CachedDataManager = CachedDataManager()

    var cache: NSCache<AnyObject, AnyObject>!
    var fileNamager: FileManager!
    var pathCacheDirectory : String!
    
    let dirName:String = "CacheByCachedDataManager"
    
    private override init() {
        super.init()
        self.cache = NSCache()
        self.cache.countLimit = 20
    }
    
    // TODO: データ保存ようの場所を作る
    
}

public extension CachedDataManager{
    
    @discardableResult public func setData(_ data:Data,
                                           key:String,
                                           validity: CachedValidity = .oneweek) -> Bool{
        
        let hashedKey = key.md5()
        return true
    }
}

