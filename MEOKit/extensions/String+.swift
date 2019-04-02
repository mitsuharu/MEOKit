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
    var md5: String {
        let data = Data(self.base.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    /// ローカライズファイルを読み込む
    var localized: String {
        return NSLocalizedString(self.base, comment: self.base)
    }
    
    /// 改行ごとに分割する
    ///
    /// - Returns: 文字型の配列
    func parsedByLines() -> [String] {
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
    
    /// 文字を描画したときの幅と高さを計算する
    ///
    /// - Parameters:
    ///   - width: 横幅．指定なしの場合は幅も任意
    ///   - font: フォント
    /// - Returns: 描画される幅と高さ
    func boundingSize(width: CGFloat = CGFloat.greatestFiniteMagnitude,
                             font: UIFont) -> CGSize {
        
        let baseSize: CGSize = CGSize(width: width,
                                      height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions(rawValue:  NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)
        
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        for str in self.parsedByLines(){
            var tmp: NSString = NSString(string: str)
            if str.count == 0{
                tmp = NSString(string: "a")
            }
            let rect: CGRect = tmp.boundingRect(with: baseSize,
                                                options: options,
                                                attributes: attributes,
                                                context: nil)
            height += rect.height
            width = max(width, rect.width)
        }
        height = CGFloat(ceilf(Float(height)))
        width = CGFloat(ceilf(Float(width)))
        return CGSize(width: width, height: height)
    }
    
    /// 横幅を指定して文字を描画したときの高さを計算する
    ///
    /// - Parameters:
    ///   - width: 横幅
    ///   - font: フォント
    /// - Returns: 指定した横幅のときの縦幅
    func boundingHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let size = self.boundingSize(width: width, font: font)
        return size.height
    }
    
}
