//
//  PaddingLabel.swift
//  MEOKit
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/// 余白ありLabel
@IBDesignable  class PaddingLabel: UILabel {
    
    public var uuid:String = UUID().uuidString
    
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8){
        didSet{
            self.drawText(in: self.frame)
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat {
        get { return padding.top }
        set { padding = UIEdgeInsets(top: newValue,
                                     left: padding.left,
                                     bottom: padding.bottom,
                                     right: padding.right) }
    }
    
    @IBInspectable public var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding = UIEdgeInsets(top: padding.top,
                                     left: newValue,
                                     bottom: padding.bottom,
                                     right: padding.right) }
    }
    
    @IBInspectable public var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding = UIEdgeInsets(top: padding.top,
                                     left: padding.left,
                                     bottom: newValue,
                                     right: padding.right) }
    }
    
    @IBInspectable public var paddingRight: CGFloat {
        get { return padding.right }
        set { padding = UIEdgeInsets(top: padding.top,
                                     left: padding.left,
                                     bottom: padding.bottom,
                                     right: newValue) }
    }
    
    @IBInspectable public var radius: CGFloat = 0.0
    public var isRadius: Bool = false{
        didSet{
            self.isRadiusTopLeft = self.isRadius
            self.isRadiusTopRight = self.isRadius
            self.isRadiusBottomLeft = self.isRadius
            self.isRadiusBottomRight = self.isRadius
        }
    }
    @IBInspectable public var isRadiusTopLeft: Bool = false
    @IBInspectable public var isRadiusTopRight: Bool = false
    @IBInspectable public var isRadiusBottomLeft: Bool = false
    @IBInspectable public var isRadiusBottomRight: Bool = false
    
    @IBInspectable public var borderColor: UIColor? = nil {
        didSet{
            if let c = borderColor{
                layer.borderColor = c.cgColor
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupRadius()
    }
    
    override public func prepareForInterfaceBuilder() {
        self.setupRadius()
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: self.padding)
        super.drawText(in: newRect)
        self.setupRadius()
    }
    
    override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        return self.fittedSize(size: contentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize = super.sizeThatFits(size)
        return self.fittedSize(size: contentSize)
    }
    
    // 余白に合うように補正する
    private func fittedSize(size: CGSize) -> CGSize{
        
        var tempSize = size
        
        if let str = self.text, str.count > 0{
 
            // 1行の高さ
            let lineHeight: CGFloat = "a".meo.boundingHeight(width: self.font.pointSize*10.0,
                                                             font: self.font)
           
            var offset: CGFloat = 0
            if size.height > lineHeight{
                // 高さが1行より大きい場合は，横幅を調整する
                // 引数のsizeはviewの大きさであり，描画エリアのサイズが異なるため
                offset = (self.padding.left + self.padding.right)
            }
            
            let h = str.meo.boundingHeight(width: tempSize.width - offset,
                                           font: self.font)
            tempSize.height = h + (self.padding.top + self.padding.bottom)
            if size.height > lineHeight{
                tempSize.width =  size.width + (self.padding.left + self.padding.right)
            }
        }else{
            tempSize.height += (self.padding.top + self.padding.bottom)
            tempSize.width += (self.padding.left + self.padding.right)
        }
        
        return tempSize
    }
    
    func setupRadius(){
        
        var hasCorners: Bool = false
        var corners: UIRectCorner = UIRectCorner()
        if self.isRadiusTopLeft{
            hasCorners = true
            corners = corners.union(.topLeft)
        }
        if self.isRadiusTopRight{
            hasCorners = true
            corners = corners.union(.topRight)
        }
        if self.isRadiusBottomLeft{
            hasCorners = true
            corners = corners.union(.bottomLeft)
        }
        if self.isRadiusBottomRight{
            hasCorners = true
            corners = corners.union(.bottomRight)
        }
        
        self.layer.mask = nil
        self.layer.cornerRadius = 0.0
        if self.radius > 0 && hasCorners{
            let size = CGSize(width: self.radius, height: self.radius)
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners:  corners,
                                        cornerRadii: size)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
}
