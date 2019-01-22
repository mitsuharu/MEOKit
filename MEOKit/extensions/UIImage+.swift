//
//  UIImage.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public extension MeoExtension where T: UIImage {
    
    /// 色違い画像を作る
    ///
    /// - Parameter color: 色
    /// - Returns: 指定色を重ねた画像
    public func colored(_ color:UIColor) -> UIImage?{
        
        let image: UIImage = self.base
        let size: CGSize = image.size
        
        let rect = CGRect(x: 0, y: 0,
                          width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.clip(to: rect, mask: image.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let result:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// 色違い画像を作る
    ///
    /// - Parameters:
    ///   - color: 色
    ///   - blendMode: ブレンドモード
    /// - Returns: 指定色を重ねた画像
    public func tintColored(_ color:UIColor, blendMode: CGBlendMode = .softLight) -> UIImage?{
        
        let image: UIImage = self.base
        let size: CGSize = image.size
        
        let rect = CGRect(x: 0, y: 0,
                          width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(rect)
        image.draw(in: rect, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != .destinationIn{
            image.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let result:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}

extension UIImage {

    /// 単色画像（四角）を生成する
    public convenience init(squareOf color: UIColor, size: CGSize) {
        if let img = UIImage.squareImage(color: color, size: size),
            let cgImage = img.cgImage{
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    /// 単色画像（丸）を生成する
    public convenience init(circleOf color: UIColor, radius:CGFloat) {
        if let img = UIImage.circleImage(color: color, radius: radius),
            let cgImage = img.cgImage{
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    /// 単色画像（四角）を生成する
    fileprivate static func squareImage(color: UIColor, size:CGSize) -> UIImage?{
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
    fileprivate static func circleImage(color: UIColor, radius:CGFloat) -> UIImage?{
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
        
}
