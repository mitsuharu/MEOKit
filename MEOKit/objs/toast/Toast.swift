//
//  Toast.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/// トースター表示を行う
public class Toast: NSObject {
    
    private var label: PaddingLabel? = nil
    private let timeInterval: TimeInterval = 2.0
    private let hiddenTimeInterval: TimeInterval = 1.0
    private static var shared: Toast = Toast()
    
    /// トースターを表示する
    ///
    /// - Parameter text: メッセージ
    public static func show(text:String){
        Toast.shared.show(text: text)
    }
    
    /// トースターを消す
    ///
    /// - Parameter isAnimated: アニメーション設定
    public static func remove(isAnimated: Bool = false){
        Toast.shared.remove(isAnimated: isAnimated)
    }
    
    private func show(text:String){

        if let label = self.label, let _ = label.superview{
            self.remove(isAnimated: false) {
                self.show(text: text)
            }
            return
        }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let w = width * 0.8
        let rect = CGRect(x: 0, y: 0, width: width, height: 16)
        
        self.label = {
            let temp = PaddingLabel(frame: rect)
            temp.backgroundColor = UIColor.gray
            temp.textColor = UIColor.white
            temp.radius = 5
            temp.radiusTopRight = true
            temp.radiusTopLeft = true
            temp.radiusBottomLeft = true
            temp.radiusBottomRight = true
            temp.numberOfLines = 0
            temp.text = text
            
            let size = temp.sizeThatFits(CGSize(width: w, height: height * 0.8))
            temp.frame = CGRect(x: (width - size.width)/2.0,
                                      y: height - size.height - 40,
                                      width: size.width,
                                      height: size.height)
            return temp
        }()
        
        if let label = self.label, let window = UIApplication.shared.keyWindow{
            window.addSubview(label)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval) {
                self.remove(isAnimated: true)
            }
        }
    }
    
    private func remove(isAnimated:Bool = true, completion:(()->())? = nil) {
        
        guard let label = self.label, let _ = label.superview else {
            return
        }
        
        var dur = 0.0
        if isAnimated{
            dur = self.hiddenTimeInterval
        }
        
        UIView.animate(withDuration: dur,
                       animations: {
                        label.alpha = 0.0
        }) { (completed) in
            label.removeFromSuperview()
            if let cmp = completion{
                cmp()
            }
        }
    }
}
