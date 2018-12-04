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


extension UIView{
    
    // autolayoutで組んで生成したViewのサイズを取得する
    public func getAutolayoutedSize(fixedWidth:CGFloat? = nil) -> CGSize{
        /*
         see:【AutoLayout】systemLayoutSizeFittingSizeでもう悩まない！ - Qiita
         https://qiita.com/netetahito/items/8b363d4c7fe5f1ca5636
         */
        
        var size:CGSize = CGSize.zero
        
        if let w = fixedWidth{
            size = self.systemLayoutSizeFitting(CGSize(width: w, height: 0),
                                                withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        }else{
            size = self.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        }
        
        let w = CGFloat(ceilf(Float(size.width)))
        let h = CGFloat(ceilf(Float(size.height)))
        let size2:CGSize = CGSize(width: w, height: h)
        
        return size2
    }
    
}
