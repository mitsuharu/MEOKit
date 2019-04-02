//
//  ViewController.swift
//  Example
//
//  Created by Mitsuhau Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import MEOKit

enum CellSource: String, CaseIterable{
    case toast = "Toast"
    case associate = "Associate (see console)"
    case cache = "Cache (see console)"
    case swizzle = "Swizzle (see console)"
    case switchOnCell = "switch on cell (see console)"
    case views = "views (pushed)"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sources: [CellSource] = CellSource.allCases
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        #if DEBUG
        DebugManager.shared.isDebug = true
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MEOKit Samples"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DLOG()
        dprint("show message if DebugManager.shared.isDebug is true ")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

// MARK: - Samples
extension ViewController{
    
    // トーストを表示する
    func sampleToast(){
        Toast.show(text: "祇園精舎の鐘の声、諸行無常の響きあり。沙羅双樹の花の色、盛者必衰の理をあらはす。おごれる人も久しからず。ただ春の夜の夢のごとし。たけき者も遂にはほろびぬ、ひとへに風の前の塵に同じ。 ")
    }
    
    // associateを確認する
    func sampleAssociate(){
        let key = "associated_key"
        self.meo.associate(obj: "アソシエイティッドデータ", key: key)
        if let str = self.meo.associated(key: key, type: String.self){
            print("str \(str)")
        }else{
            print("str nil")
        }
    }
    
    // キャッシュデータの確認
    func samoleCacheData(){
        let key:String = "keykeykey"
        Cached.add(string: "キャッシュデータ", key: key)
        if let str = Cached.string(key: key){
            print("str \(str)")
        }
    }
    
    func sampleSwizzle(){
        let key = "swizzled"
        var title: String{
            get{
                if self.meo.isOnced(key: key){
                    return "swizzled"
                }else{
                    return "unswizzled"
                }
            }
        }
        
        print("[\(title)] self.test01() = \(self.test01())")
        print("[\(title)] self.test02() = \(self.test02())")

        self.meo.once(key: key) {
//            self.meo.swizzle(from: #selector(viewDidAppear(_:)),
//                             to: #selector(viewDidAppear2(_:)))
            self.meo.swizzle(from: #selector(test01),
                             to: #selector(test02))
        }
        
        print("[swizzled] self.test01() = \(self.test01())")
        print("[swizzled] self.test02() = \(self.test02())")
    }
    
    @objc dynamic func test01() -> String {
        return "test01"
    }
    
    @objc dynamic func test02() -> String  {
        return "test02"
    }
    
    @objc dynamic func viewDidAppear2(_ animated: Bool) {
        viewDidAppear2(animated)
        print("viewDidAppear2")
    }
    
    func sampleViews()  {
        let vc = SampleViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - for TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .default
        
        let source = self.sources[indexPath.row]
        cell.textLabel?.text = source.rawValue
        
        cell.meo.removeAccessoryView()
        if source == .switchOnCell{
            cell.selectionStyle = .none
            let fistValue = false
            cell.meo.addSwitch(isOn: fistValue) { (cell, sw) in
                print("changed isOn:\(sw.isOn)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let source:CellSource = self.sources[indexPath.row]
        switch source {
        case .toast:
            self.sampleToast()
        case .associate:
            self.sampleAssociate()
        case .cache:
            self.samoleCacheData()
        case .swizzle:
            self.sampleSwizzle()
        case .views:
            self.sampleViews()
        case .switchOnCell:
            break
        }
    }
    
    
}
