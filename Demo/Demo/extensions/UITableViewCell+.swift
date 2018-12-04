//
//  UITableViewCell+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import ObjectiveC

private var switchSelectorKey = "switchSelectorKey"

extension UITableViewCell {

    // MARK: - commons
    public func removeAccessoryView() {
        self.removeSwith()
        
        self.textLabel?.text = nil
        self.imageView?.image = nil
        self.accessoryView = nil
    }
    
    // MARK: - Switch
    
    public typealias SwitchHandler = (_ cell:UITableViewCell, _ sw:UISwitch) -> Void
    
    public func addSwitch(isOn: Bool, completion:@escaping SwitchHandler) {
        let swtch: UISwitch = UISwitch()
        swtch.isOn = isOn
        swtch.addTarget(self, action: #selector(self.doSwitch(sw:)), for: UIControl.Event.valueChanged)
        objc_setAssociatedObject(self,
                                 &switchSelectorKey,
                                 completion,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.accessoryView = swtch        
    }
    
    public func removeSwith()  {
        objc_setAssociatedObject(self,
                                 &switchSelectorKey,
                                 nil,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.accessoryView = nil
    }
    
    @objc private func doSwitch(sw: UISwitch) {
        if let handler = objc_getAssociatedObject(self, &switchSelectorKey) as? SwitchHandler{
            handler(self, sw)
        }
    }
    


}

