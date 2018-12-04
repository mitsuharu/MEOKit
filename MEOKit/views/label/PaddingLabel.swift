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
    @IBInspectable public var radiusTopLeft: Bool = false
    @IBInspectable public var radiusTopRight: Bool = false
    @IBInspectable public var radiusBottomLeft: Bool = false
    @IBInspectable public var radiusBottomRight: Bool = false
    
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
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentSize = super.sizeThatFits(size)
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }
    
    func setupRadius(){
        
        var hasCorners: Bool = false
        var corners: UIRectCorner = UIRectCorner()
        if self.radiusTopLeft{
            hasCorners = true
            corners = corners.union(.topLeft)
        }
        if self.radiusTopRight{
            hasCorners = true
            corners = corners.union(.topRight)
        }
        if self.radiusBottomLeft{
            hasCorners = true
            corners = corners.union(.bottomLeft)
        }
        if self.radiusBottomRight{
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
