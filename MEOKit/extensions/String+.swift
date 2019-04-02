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
    
    /// 部分文字列を取得する
    ///
    /// - Parameters:
    ///   - index: 開始位置
    ///   - length: 文字列の長さ
    /// - Returns: 文字列
    func sub(index: Int, length: Int) -> String? {
        let str: String = self.base
        if index < str.count && (index + length) <= str.count{
            let startIndex = str.index(str.startIndex, offsetBy: index)
            let endIndex = str.index(startIndex, offsetBy: length)
            return String(str[startIndex..<endIndex])
        }
        return nil
    }
    
    /// 部分文字列を取得する
    ///
    /// - Parameter range: NSRange型で開始位置と長さを指定する
    /// - Returns: 文字列
    func sub(range: NSRange) -> String?{
        return self.sub(index: range.location, length: range.length)
    }
    
    /// 正規表現でマッチする範囲を取得する
    ///
    /// - Parameter pattern: パターン（例えば，数字なら"\\d"）
    /// - Returns: NSRangeの配列
    func rangesByRegex(pattern: String) -> [NSRange]{
        let str: String = self.base
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let r = NSRange(location: 0, length: str.count)
        let matches:[NSTextCheckingResult] = regex.matches(in: str, range: r)
        if matches.count == 0{
            return []
        }
        return matches.map{$0.range}
    }
}
