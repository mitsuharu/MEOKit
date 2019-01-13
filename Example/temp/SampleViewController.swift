//
//  SampleViewController.swift
//  Demo
//
//  Created by Mitsuharu Emoto on 2018/12/04.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    var sampleView: SampleView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addSampleView()
    }
    
    func addSampleView() {
        if let v = self.sampleView{
            v.removeFromSuperview()
        }
        self.sampleView = {
            let v = SampleView.instantiate()
            v.frame = CGRect(x: 10, y: 100, width: 200, height: 100)
            return v
        }()
        if let v = self.sampleView{
            self.view.addSubview(v)
            if let str = v.accessibilityIdentifier{
                print("sampleView.accessibilityIdentifier (isDeug) = \(str)")
            }
        }
    }
}
