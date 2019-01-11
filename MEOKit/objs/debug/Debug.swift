//
//  Debug.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/16.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit



/// DEBUG用print
///
/// DEBUGマクロが未設定の場合は， Target > Build Settings > Preprosessor Macros に DEBUG=1 を追加する
///
/// #if DEBUG
/// DebugManager.shared.isDebug = true
/// #endif
///
/// - Parameters:
///   - string: 標準出力に表示する文字列
///   - function: 関数名（指定不要）
///   - line: 行数（指定不要）
///
public func dprint(_ string: String? = nil,
                   function: String = #function, line: Int = #line){
    if DebugManager.shared.isDebug == false{
        return
    }
    
    let format:DateFormatter = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    format.timeZone = NSTimeZone.system
    format.locale = NSLocale.system
    
    let date:NSDate = NSDate()
    let dateStr = format.string(from: date as Date)
    
    var str = "nil"
    if let s = string{
        str = s
    }
    print("\(dateStr) \(function)[\(line)] \(str)")
}

/// DEBUG用DLOG
///
/// DEBUGマクロが未設定の場合は， Target > Build Settings > Preprosessor Macros に DEBUG=1 を追加する
///
/// - Parameters:
///   - string: 標準出力に表示する文字列
///   - function: 関数名（指定不要）
///   - line: 行数（指定不要）
public func DLOG(_ string: String? = nil,
                 function: String = #function, line: Int = #line){
    dprint(string, function:function, line:line);
}

public class DebugManager: NSObject{
    public static var shared:DebugManager = DebugManager()
    public var isDebug: Bool = false
}


//extension UIView{
//    //  accessibilityIdentifier
//    
//    public var accessibilityIdentifier: String? {
//        
//        if DebugManager.shared.isDebug == false{
//            return super.accessibilityIdentifier
//        }
//        
//        return nil
//        
//    }
//
//}

