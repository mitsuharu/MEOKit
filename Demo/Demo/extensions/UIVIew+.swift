//
//  UIVIew+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIView {
        
    public static func instantiate(nibName:String? = nil) -> Self{
        return instantiateHelper(nibName: nibName)
    }
    
    private static func instantiateHelper<T>(nibName:String? = nil) -> T{
        
        var clsName = String(describing: type(of: T.self))
        if let range = clsName.range(of: ".Type") {
            clsName.replaceSubrange(range, with: "")
        }
        var name = clsName
        if nibName != nil{
            name = nibName!
        }
        
        let nb = UINib(nibName: name, bundle: Bundle.main)
        let v = nb.instantiate(withOwner: nil, options: nil)[0]
        let result = v as! T
        return result
    }

    
}
