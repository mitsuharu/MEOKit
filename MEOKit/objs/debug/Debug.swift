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
/// - Parameters:
///   - string: 標準出力に表示する文字列
///   - function: 関数名（指定不要）
///   - line: 行数（指定不要）
public func dprint(_ string: String = "",
                   function: String = #function, line: Int = #line){
    if DebugManager.shared.debug == false{
        return
    }
    
    let format:DateFormatter = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    format.timeZone = NSTimeZone.system
    format.locale = NSLocale.system
    
    let date:NSDate = NSDate()
    let dateStr = format.string(from: date as Date)
    
    print("\(dateStr) \(function)[\(line)] \(string)")
}

/// DEBUG用DLOG
///
/// DEBUGマクロが未設定の場合は， Target > Build Settings > Preprosessor Macros に DEBUG=1 を追加する
///
/// - Parameters:
///   - string: 標準出力に表示する文字列
///   - function: 関数名（指定不要）
///   - line: 行数（指定不要）
public func DLOG(_ string: String = "",
                 function: String = #function, line: Int = #line){
    dprint(string, function:function, line:line);
}

public class DebugManager: NSObject{
    
    public static var shared:DebugManager = DebugManager()
    private var _debug: Bool = false
    public var debug: Bool{
        set(p){
            self._debug = p
        }
        get{
            var temp: Bool = self._debug
            #if DEBUG
            temp = true
            #endif
            return temp
        }
    }
}


