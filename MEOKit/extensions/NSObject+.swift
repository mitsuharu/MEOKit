//
//  NSObject+.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension NSObject {
        
    public var className: String {
        get {
            var name = String(describing: type(of: self))
            if let range = name.range(of: ".Type") {
                name.replaceSubrange(range, with: "")
            }
            return name
        }
    }
    
}
