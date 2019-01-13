//
//  String+.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import CommonCrypto

// Stringの自作extension
public extension MeoExtension where T == String {
    
    /// MD5で暗号化する
    public var md5: String {
        let data = self.base.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes{CC_MD5($0, CC_LONG(data.count), &digest)}
        let crypt = digest.map{String(format: "%02x", $0)}.joined(separator: "")
        return crypt
    }
    
    /// ローカライズファイルを読み込む
    public var localized: String {
        return NSLocalizedString(self.base, comment: self.base)
    }
    
    /// 改行ごとに分割する
    public func parsedByLines() -> [String] {
        var lines: [String] = [String]()
        self.base.enumerateLines { (line, stop) in
            lines.append(line)
        }
        let temp = self.base.components(separatedBy: CharacterSet.newlines)
        if let last = temp.last{
            if temp.count > 1 && last == ""{
                lines.append(last)
            }
        }
        return lines
    }
    
    /// 横幅を指定して文字を描画したときの高さを計算する
    public func drawnHeight(width:CGFloat, font:UIFont) -> CGFloat {
        
        let size: CGSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attrDict = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue
        
        var height: CGFloat = 0
        for str in self.parsedByLines(){
            var tempHeight: CGFloat = 0
            if str.count == 0{
                let rect:CGRect = NSString(string: "a").boundingRect(with: size,
                                                                     options: NSStringDrawingOptions(rawValue: options),
                                                                     attributes: attrDict,
                                                                     context: nil)
                tempHeight = rect.height
            }else{
                let rect:CGRect = NSString(string: str).boundingRect(with: size,
                                                                     options: NSStringDrawingOptions(rawValue: options),
                                                                     attributes: attrDict,
                                                                     context: nil)
                tempHeight = rect.height
            }
            height += tempHeight
        }
        height = CGFloat(ceilf(Float(height)))
        return height
    }
    
}
