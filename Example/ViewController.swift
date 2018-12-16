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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("className \(self.className)")
        print("classDescription \(self.classDescription)")

        let v = SampleView.instantiate()
        v.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        v.backgroundColor = UIColor(hexCode: "FF00FF")
        self.view.addSubview(v)
        
        Toast.show(text: "祇園精舎の鐘の声、諸行無常の響きあり。沙羅双樹の花の色、盛者必衰の理をあらはす。おごれる人も久しからず。ただ春の夜の夢のごとし。たけき者も遂にはほろびぬ、ひとへに風の前の塵に同じ。 ")
        
        let key:String = "jsjgogewoj"
        CachedData.setString("キャッシュデータ", key: key)
        if let str = CachedData.string(key: key){
            print("str \(str)")
        }
        
        DLOG("あいうえお")
    }


}

