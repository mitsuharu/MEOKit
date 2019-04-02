//
//  Attributed.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/04/02.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/**
 NSAttributedStringの作成を補助する
 
 修飾はドッド繋ぎで追加するできる
 ```Swift
 let attributed = Attributed("test").font(UIFont.systemFont(ofSize: 30)).color(UIColor.cyan)
 let attr: NSAttributedString = attributed.string
 ```
 修飾辞書データのみが欲しいときは，初期時に文字列の指定は不要
 ```Swift
 let attributed = Attributed().font(UIFont.systemFont(ofSize: 30)).color(UIColor.cyan)
 let dict: [NSAttributedString.Key: Any] = attributed.dict
 ```
*/
public class Attributed: NSObject{
    
    private var _string: String? = nil
    var dict: [NSAttributedString.Key: Any] = [:]
    
    init(_ string: String? = nil) {
        self._string = string
    }
    
    public var string: NSAttributedString?{
        guard let str = self._string else {
            return nil
        }
        return NSMutableAttributedString(string: str, attributes: self.dict)
    }
    
    public func font(_ font: UIFont) -> Self {
        self.dict.updateValue(font, forKey: .font)
        return self
    }
    
    public func color(_ color: UIColor) -> Self {
        self.dict.updateValue(color, forKey: .foregroundColor)
        return self
    }
    
    func kern(_ kern: CGFloat) -> Self {
        self.dict.updateValue(kern, forKey: .kern)
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> Self {
        self.dict.updateValue(color, forKey: .backgroundColor)
        return self
    }
    
    func baselineOffset(_ offset: CGFloat) -> Self {
        self.dict.updateValue(offset, forKey: .baselineOffset)
        return self
    }
    
    func underline(color: UIColor, style: NSUnderlineStyle) -> Self {
        self.dict.updateValue(style.rawValue, forKey: .underlineStyle)
        self.dict.updateValue(color, forKey: .underlineColor)
        return self
    }
}
