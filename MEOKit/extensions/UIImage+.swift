//
//  UIImage.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIImage {

    /// 単色画像を生成する
    public convenience init(color: UIColor, size: CGSize) {
        if let img = UIImage.squareImage(color: color, size: size),
            let cgImage = img.cgImage{
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    /// 単色画像（四角）を生成する
    public static func squareImage(color: UIColor, size:CGSize) -> UIImage?{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 単色画像（丸）を生成する
    public static func circleImage(color: UIColor, radius:CGFloat) -> UIImage?{
        let rect = CGRect(x: 0, y: 0, width: radius*2.0, height: radius*2.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: rect)
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 色違い画像を作る
    public func colored(color:UIColor) -> UIImage?{
        let rect = CGRect(x: 0, y: 0,
                          width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.clip(to: rect, mask: self.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 色違い画像を作る
    public func tintColored(color:UIColor, blendMode: CGBlendMode = .softLight) -> UIImage?{
        let rect = CGRect(x: 0, y: 0,
                          width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(rect)
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != .destinationIn{
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
        
}
