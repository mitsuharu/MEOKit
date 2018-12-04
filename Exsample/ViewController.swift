//
//  ViewController.swift
//  Exsample
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit
import MEOKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        let vc = SampleViewController.instantiate(storyboardName: nil, storyboardId: nil)
        //        self.present(vc, animated: true, completion: nil)
        
        let v = SampleView.instantiate()
        v.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        self.view.addSubview(v)
        
        Toast.show(text: "祇園精舎の鐘の声、諸行無常の響きあり。沙羅双樹の花の色、盛者必衰の理をあらはす。おごれる人も久しからず。ただ春の夜の夢のごとし。たけき者も遂にはほろびぬ、ひとへに風の前の塵に同じ。 ")
    }


}

