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

    private var label: PaddingLabel!
    private let timeInterval: TimeInterval = 2.0
    private let hiddenTimeInterval: TimeInterval = 1.0
    private static var shared: Toast = Toast()
    
    /// トースターを表示する
    public static func show(text:String){
        Toast.shared.show(text: text)
    }
    
    /// トースターを消す
    public static func remove(isAnimated: Bool = false){
        Toast.shared.remove(isAnimated: isAnimated)
    }
    
    private func show(text:String){
        
        if let _ = self.label{
            self.remove(isAnimated: false)
        }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let w = width * 0.8
        let rect = CGRect(x: 0, y: 0, width: width, height: 16)
        
        self.label = PaddingLabel(frame: rect)
        self.label.backgroundColor = UIColor.gray
        self.label.textColor = UIColor.white
        self.label.radius = 5
        self.label.radiusTopRight = true
        self.label.radiusTopLeft = true
        self.label.radiusBottomLeft = true
        self.label.radiusBottomRight = true
        self.label.numberOfLines = 0
        self.label.text = text
        
        let size = self.label.sizeThatFits(CGSize(width: w, height: height * 0.8))
        self.label.frame = CGRect(x: (width - size.width)/2.0,
                                  y: height - size.height - 40,
                                  width: size.width,
                                  height: size.height)
 
        if let window = UIApplication.shared.keyWindow{
           window.addSubview(self.label)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval) {
            self.remove()
        }
    }
    
    private func remove(isAnimated:Bool = true) {

        guard let label = self.label else {
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
            self.label = nil
        }
    }
}
