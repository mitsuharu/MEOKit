//
//  UIViewController+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UIViewController {
    
    /// 自身が表示されているか判定する
    public var isAppeared: Bool{
        get{
            let vc: UIViewController = self.base
            if let pvc = vc.presentedViewController{
                return (pvc == vc && (vc.isViewLoaded && vc.view.window != nil))
            }else if let nc = vc.navigationController{
                return (nc.visibleViewController == vc)
            }else if let tc = vc.tabBarController{
                return (tc.selectedViewController == vc && vc.presentedViewController == nil)
            }
            return false
        }
    }
    
}

extension UIViewController {
    
    /// storyboardから生成する
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

    /// 最も前面にあるViewControllerを取得する
    static func topLayerViewController() -> UIViewController?{
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        guard var vc = window.rootViewController else {
            return nil
        }
        while let tmp = vc.presentedViewController {
            vc = tmp
        }
        return vc
    }
}
