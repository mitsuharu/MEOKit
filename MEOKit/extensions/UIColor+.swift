//
//  UIColor+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/// RGBを 0 - 255 の範囲で，Aを 0 - 1 の範囲で UIColor を生成する
public func RGBA(_ r:Int, _ g:Int, _ b:Int, _ a:CGFloat) -> UIColor{
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0,
                   blue: CGFloat(b)/255.0, alpha: a)
}

/// RGBを 0 - 255 の範囲で UIColor を生成する
public func RGB(_ r:Int, _ g:Int, _ b:Int) -> UIColor{
    return RGBA(r, g, b, 1.0)
}

/// 16進数で指定したカラーコードで UIColor を生成する
public func HEXCOLOR(_ hexCode: String)  -> UIColor{
    return UIColor(hexCode: hexCode)
}

public extension MeoExtension where T: UIColor {
    
    /// ダークカラーを生成する
    public var darkColor: UIColor{
        let color = UIColor(white: 0.0, alpha: 0.5)
        return self.blend(color: color, weight: 0.5)
    }
    
    /// 色を合成する
    public func blend(color: UIColor, weight:CGFloat) -> UIColor{
        
        var r0: CGFloat = 1.0
        var g0: CGFloat = 1.0
        var b0: CGFloat = 1.0
        var a0: CGFloat = 1.0
        var r1: CGFloat = 1.0
        var g1: CGFloat = 1.0
        var b1: CGFloat = 1.0
        var a1: CGFloat = 1.0
        
        self.base.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)
        color.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        let r: CGFloat = r1 * weight + r0 * (1.0 - weight)
        let g: CGFloat = g1 * weight + g0 * (1.0 - weight)
        let b: CGFloat = b1 * weight + b0 * (1.0 - weight)
        let a: CGFloat = a1 * weight + a0 * (1.0 - weight)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}

extension UIColor{
    
    /// 16進数でUIColorを生成する
    ///
    /// - Parameters:
    ///   - hexCode: 16進数 "FFFFFF" or "#000000"
    ///   - a: アルファ値（デフォルト1.0）
    public convenience init(hexCode: String, a: CGFloat = 1.0) {
        let (r, g, b) = UIColor.hexCode2RGB(hexCode: hexCode)
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0,
                  blue: CGFloat(b)/255.0, alpha: a)
    }
    
    /// 文字列の16進数からRGBを取得する
    fileprivate static func hexCode2RGB(hexCode:String) -> (Int, Int, Int){
        var colorCode = hexCode
        for tmp in ["0x", "#"]{
            if let range = colorCode.range(of: tmp) {
                colorCode.replaceSubrange(range, with: "")
            }
        }
        let rv:Int? = colorCode.sub(startIndex: 0, length: 2).hexToInt()
        let gv:Int? = colorCode.sub(startIndex: 2, length: 2).hexToInt()
        let bv:Int? = colorCode.sub(startIndex: 4, length: 2).hexToInt()
        if let r = rv, let g = gv, let b = bv{
            return (r, g, b)
        }
        return (0, 0, 0)
    }
}


extension String{
    
    fileprivate func sub(startIndex:Int, length:Int) -> String{
        let startIndex = self.index(self.startIndex, offsetBy: startIndex)
        let endIndex = self.index(startIndex, offsetBy: length)
        return String(self[startIndex..<endIndex])
    }
    
    fileprivate func hexToInt() -> Int?{
        return Int(self, radix: 16)
    }
}
