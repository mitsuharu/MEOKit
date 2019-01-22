//
//  UIVIew+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UIView {
    
    /// 自身をaddしたUIViewControllerを取得する
    public var viewController: UIViewController?{
        return self.base.parent(type: UIViewController.self)
    }
    
    /// autolayoutで組んで生成したViewのサイズを取得する
    ///
    /// - Parameter fixedWidth: viewの固定幅．nilのときは自由幅
    /// - Returns: 生成されるviewサイズ
    public func autolayoutSize(fixedWidth:CGFloat? = nil) -> CGSize{
        /*
         see:【AutoLayout】systemLayoutSizeFittingSizeでもう悩まない！ - Qiita
         https://qiita.com/netetahito/items/8b363d4c7fe5f1ca5636
         */
        
        let view: UIView = self.base
        var size:CGSize = CGSize.zero
        if let w = fixedWidth{
            let hor = UILayoutPriority.required
            let ver = UILayoutPriority.fittingSizeLevel
            size = view.systemLayoutSizeFitting(CGSize(width: w, height: 0),
                                                withHorizontalFittingPriority: hor,
                                                verticalFittingPriority: ver)
        }else{
            size = view.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        }
        
        let w = CGFloat(ceilf(Float(size.width)))
        let h = CGFloat(ceilf(Float(size.height)))
        let size2:CGSize = CGSize(width: w, height: h)
        return size2
    }
    
    /// view を addSubview したときにサイズも設定する
    ///
    /// - Parameter view: 表示するview
    public func addAndFitSubview(_ view:UIView){
        self.base.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = self.base.translatesAutoresizingMaskIntoConstraints
        if view.translatesAutoresizingMaskIntoConstraints {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = self.base.bounds
        } else {
            view.topAnchor.constraint(equalTo: self.base.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.base.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.base.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.base.rightAnchor).isActive = true
        }
    }
    
    /// 背景に画像を設定する
    ///
    /// - Parameter image: 背景に設定する画像
    public func setBackgroundImage(image:UIImage){
        UIGraphicsBeginImageContext(self.base.frame.size)
        image.draw(in: self.base.bounds)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = resizedImage else {
            return
        }
        self.base.backgroundColor = UIColor(patternImage: img)
    }
    
    /// viewを画像にする
    public var exportImage: UIImage?{
        get{
            UIGraphicsBeginImageContextWithOptions(self.base.bounds.size, false, 0.0)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.base.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
}

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

