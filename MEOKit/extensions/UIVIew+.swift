//
//  UIVIew+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIView {
    
    /// nibファイルから生成する
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
    
    /// autolayoutで組んで生成したViewのサイズを取得する
    public func autolayoutSize(fixedWidth:CGFloat? = nil) -> CGSize{
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
    
    /// view を addSubview したときにサイズも設定する
    public func addAndFitSubview(_ view:UIView){
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints
        if view.translatesAutoresizingMaskIntoConstraints {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = self.bounds
        } else {
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
    }

    /// 背景に画像を設定する
    public func setBackgroundImage(image:UIImage){
        UIGraphicsBeginImageContext(self.frame.size)
        image.draw(in: self.bounds)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = resizedImage else {
            return
        }
        self.backgroundColor = UIColor(patternImage: img)
    }
    
    /// viewを画像にする
    public var exportedImage: UIImage?{
        get{
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}
