//
//  ViewController.swift
//  HDCoverageDemo
//
//  Created by denglibing on 2021/10/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dosomething()
    }


    private func dosomething() {
        let random = arc4random() % 100
        if random % 2 == 0 {
            debugPrint("0")
            zero()
        }
        else {
            debugPrint("1")
            one()
        }
        
        HDOC.changeViewColor(view)
        
        HDOCFramework.changeViewColor(view)
    }
    
    private func zero() {
        self.view.backgroundColor = .orange
    }
    
    private func one() {
        self.view.backgroundColor = .darkGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dosomething()
    }
}

