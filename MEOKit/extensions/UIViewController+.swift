//
//  UIViewController+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static func instantiate(storyboardName:String? = nil,
                                   storyboardId:String? = nil) -> Self{
        return instantiateHelper(storyboardName: storyboardName, storyboardId: storyboardId)
    }
    
    private static func instantiateHelper<T>(storyboardName:String? = nil,
                                   storyboardId:String? = nil) -> T{
        
        var name = String(describing: type(of: T.self))
        if let range = name.range(of: ".Type") {
            name.replaceSubrange(range, with: "")
        }
        var sbName = name
        var idName = name
  
        if storyboardName != nil{
            sbName = storyboardName!
        }
        if storyboardId != nil{
            idName = storyboardId!
        }
        
        let sb = UIStoryboard(name: sbName, bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: idName)
        let result = vc as! T
        return result
    }

}
