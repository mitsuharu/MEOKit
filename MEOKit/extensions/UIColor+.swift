//
//  UIColor+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

extension UIColor{
    
    public static func RGBA(r:Int, g:Int, b:Int, a:Int=1) -> UIColor{
        return UIColor(red: CGFloat(r)/255.0,
                       green: CGFloat(b)/255.0,
                       blue: CGFloat(b)/255.0,
                       alpha: CGFloat(a))
    }
    
    public static func HEX(hexCode: String) -> UIColor{
        let (r, g, b) = hexCode2RGB(hexCode: hexCode)
        return RGBA(r: r, g: g, b: b)
    }
    
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
