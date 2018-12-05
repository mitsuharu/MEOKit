//
//  UIColor+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIColor{
    
    /// RBGA(0 - 255)でUIColorを生成する
    private convenience init(r:Int, g:Int, b:Int, a:CGFloat=1.0) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0,
                  blue: CGFloat(b)/255.0, alpha: a)
    }
    
    /// 16進数でUIColorを生成する
    public convenience init(hexCode: String, a: CGFloat = 1.0) {
        let (r, g, b) = UIColor.hexCode2RGB(hexCode: hexCode)
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0,
                  blue: CGFloat(b)/255.0, alpha: a)
    }
    
    /// RBGAでUIColorを生成する
    public static func RGBA(r:Int, g:Int, b:Int, a:CGFloat=1.0) -> UIColor{
        return UIColor(r: r, g: g, b: b, a: a)
    }
    
    /// 16進数でUIColorを生成する
    public static func HEX(hexCode: String, a:CGFloat=1.0) -> UIColor{
        return UIColor(hexCode: hexCode, a: a)
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
    
    /// ダークカラーを生成する
    public func darkColor() -> UIColor{
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

        self.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)
        color.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        let r: CGFloat = r1 * weight + r0 * (1.0 - weight)
        let g: CGFloat = g1 * weight + g0 * (1.0 - weight)
        let b: CGFloat = b1 * weight + b0 * (1.0 - weight)
        let a: CGFloat = a1 * weight + a0 * (1.0 - weight)
        return UIColor(red: r, green: g, blue: b, alpha: a)
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
