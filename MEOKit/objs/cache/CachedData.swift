//
//  CachedData.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/08.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public enum CachedDataValidity: Int{
    case oneweek
    case oneday
}

// キャッシュデータ
public class CachedData: NSObject {
    
    public var data: Data!
    var uuid: String = NSUUID().uuidString
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var expiredAt: Date!
    var validity: CachedDataValidity = .oneweek
    
    convenience init(data: Data,
                     validity: CachedDataValidity = .oneweek ) {
        self.init()
        self.data = data
        self.updateExpiredAt(validity: validity)
    }
    
    // 有効期限の更新
    func updateExpiredAt(validity: CachedDataValidity){
        var timeInterval: TimeInterval = 0.0
        let oneDaySec: TimeInterval = 86400.0
        
        switch validity {
        case .oneweek:
            timeInterval = oneDaySec*7.0
        case .oneday:
            timeInterval = oneDaySec
        }
        
        self.validity = validity
        self.expiredAt = Date(timeInterval: timeInterval,
                              since: self.updatedAt)
    }
}
