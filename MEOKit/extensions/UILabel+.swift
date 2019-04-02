//
//  UILabel+.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2019/02/02.
//  Copyright © 2019 Mitsuharu Emoto. All rights reserved.
//

import UIKit

// UILabelの自作extension
public extension MeoExtension where T : UILabel {
    
    /// 描画するときのサイズを習得する
    ///
    /// - Parameter width: 指定幅のときは設定する．幅も求める場合は指定しない．．
    /// - Returns: 描画されるサイズ
    func boundingSize(width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        var size: CGSize = CGSize.zero
        let label: UILabel = self.base
        if let str = label.text{
            size = str.meo.boundingSize(width: width, font: label.font)
        }
        return size
    }
    
    /// 描画するときの高さを習得する
    ///
    /// - Parameter width: 指定幅
    /// - Returns: 高さ
    func boundingHeight(width: CGFloat) -> CGFloat {
         let size = self.boundingSize(width: width)
        return size.height
    }
    
}

extension UILabel{
    
}

