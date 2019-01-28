//
//  UITableViewCell+.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import ObjectiveC

public extension MeoExtension where T: UITableViewCell {
    
    /// 自身をaddしたUITableViewを取得する
    public var tableView: UITableView? {
        return self.base.parent(type: UITableView.self)
    }
    
    /// 自身のIndexPathを取得する
    public var indexPath: IndexPath? {
        guard let tv: UITableView = self.tableView else {
            return nil
        }
        return tv.indexPath(for: self.base)
    }
    
    /// 自身を reloadRows() する
    ///
    /// - Parameter animation: アニメーション（デフォルトは.automatic）
    /// - Returns: reloadできたらtrue
    @discardableResult
    public func reload(animation: UITableView.RowAnimation = .automatic) -> Bool{
        guard
            let tv: UITableView = self.tableView,
            let ip: IndexPath = tv.indexPath(for: self.base) else {
                return false
        }
        
        var result: Bool = false
        let sections: Int = tv.numberOfSections
        let rows: Int = tv.numberOfRows(inSection: sections)
        let hasIndexPath: Bool = (ip.section < sections) && (ip.row < rows)
        if let ips = tv.indexPathsForVisibleRows, ips.contains(ip) && hasIndexPath{
            tv.beginUpdates()
            tv.reloadRows(at: [ip], with: animation)
            tv.endUpdates()
            result = true
        }
        return result
    }
    
}

// ハンドラー
public typealias SwitchHandler = (_ cell:UITableViewCell, _ sw:UISwitch) -> Void

// キー
private var switchSelectorKey = "switchSelectorKey"

// アクセサリー関連
public extension MeoExtension where T: UITableViewCell {
    
    /// 掃除
    public func removeAccessoryView() {
        self.removeSwith()
        self.base.accessoryView = nil
    }
    
    /// アクセサリービューにスイッチを追加する
    ///
    /// - Parameters:
    ///   - isOn: スイッチの初期isOn
    ///   - completion: スイッチを入れ替えた時のイベントハンドラー
    public func addSwitch(isOn: Bool, completion:@escaping SwitchHandler) {
        let swtch: UISwitch = UISwitch()
        swtch.isOn = isOn
        swtch.addTarget(self.base,
                        action: #selector(self.base.doSwitch(sw:)),
                        for: UIControl.Event.valueChanged)
        let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
        objc_setAssociatedObject(self.base, &switchSelectorKey,
                                 completion, policy)
        self.base.accessoryView = swtch
    }
    
    /// スイッチの削除
    public func removeSwith()  {
        objc_setAssociatedObject(self.base,
                                 &switchSelectorKey,
                                 nil,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.base.accessoryView = nil
    }
}


extension UITableViewCell {

    @objc fileprivate func doSwitch(sw: UISwitch) {
        if let handler = objc_getAssociatedObject(self, &switchSelectorKey) as? SwitchHandler{
            handler(self, sw)
        }
    }
}

