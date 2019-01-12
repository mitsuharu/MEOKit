//
//  ViewController.swift
//  Example
//
//  Created by Mitsuhau Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import MEOKit

class ViewController: UIViewController {

    var tempView: UIView = UIView(frame: CGRect.zero)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DebugManager.shared.isDebug = true
        
//        self.meo.swizzle(from: #selector(viewDidAppear(_:)),
//                         to: #selector(viewDidAppear2(_:)))
//
//        self.meo.swizzle(from: #selector(test01),
//                         to: #selector(test02))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let aaa: String = "aaa".meo.md5
        print("tste \(aaa)")
        
        let key2 = "test"
        self.meo.associate(obj: "agavearge", forKey: key2)
        if let str = self.meo.associated(key: key2, type: String.self){
            print("str2 \(str)")
        }else{
            print("str2 nillll")
        }
        
    //    print("accessibilityIdentifier \(self.view.accessibilityIdentifier)")
        
       
        self.view.addSubview(tempView)
        print("tempView \(tempView.accessibilityIdentifier)")
        
//        print("className \(self.meo.className)")
//        print("classDescription \(self.meo.classDescription)")

        let v = SampleView.instantiate()
        v.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        v.backgroundColor = UIColor(hexCode: "FF00FF")
        self.view.addSubview(v)
        
     //   print("SampleView \(v.accessibilityIdentifier)")
        
        Toast.show(text: "祇園精舎の鐘の声、諸行無常の響きあり。沙羅双樹の花の色、盛者必衰の理をあらはす。おごれる人も久しからず。ただ春の夜の夢のごとし。たけき者も遂にはほろびぬ、ひとへに風の前の塵に同じ。 ")
        
        let key:String = "jsjgogewoj"
        CachedData.setString("キャッシュデータ", key: key)
        if let str = CachedData.string(key: key){
            print("str \(str)")
        }
        
        DLOG()
        dprint()
        DLOG("aaaa")
        dprint("aaa")
        DLOG("あいうえお")
        
        self.test01()
//        self.test02()
//        
//        print("----- swizzled")
//        
////        self.swizzle(from: #selector(ViewController.test01),
////                     to: #selector(ViewController.test02))
//        
//        self.test01()
//        self.test02()
    }

    
    @objc dynamic func test01()  {
        print("test01")
    }
    
    @objc dynamic func test02()  {
        print("test02")
    }

    @objc dynamic func viewDidAppear2(_ animated: Bool) {
        viewDidAppear2(animated)
        print("viewDidAppear2")
    }
}

