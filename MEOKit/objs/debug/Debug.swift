//
//  Debug.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/16.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

// Target > Build Settings > Preprosessor Macros に DEBUG=1 を追加する

import UIKit

private func dprint<T>(contents: T, function: String = #function, line: Int = #line)
{
    if DebugManager.shared.debug == false{
        return
    }
    
    let format:DateFormatter = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    format.timeZone = NSTimeZone.system
    format.locale = NSLocale.system
    
    let date:NSDate = NSDate()
    let dateStr = format.string(from: date as Date)
    
    var isVoid:Bool = false
    if let str:String = contents as? String{
        isVoid = (str.count == 0)
    }
    
    if isVoid {
        print("\(dateStr) \(function)[\(line)]")
    }else{
        print("\(dateStr) \(function)[\(line)] \(contents)")
    }
}

public func DLOG(function: String = #function, line: Int = #line){
    dprint(contents:"", function:function, line:line);
}

public func DLOG<T>(_ contents: T, function: String = #function, line: Int = #line){
    dprint(contents:contents, function:function, line:line);
}

public class DebugManager: NSObject{
    
    public static var shared:DebugManager = DebugManager()
    var debug: Bool{
        get{
            var temp: Bool = false
            #if DEBUG
            temp = true
            #endif
            return temp
        }
    }
}


