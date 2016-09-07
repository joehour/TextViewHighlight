//
//  ViewController.swift
//  Example
//
//  Created by JoeJoe on 2016/7/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

import UIKit
import TextViewHighlight

class ViewController: UIViewController {

    @IBOutlet weak var testTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testTextView.setMutiContentView("Sample: %mark<Mark;> %mark<Color code; #ff1234> %link<Google[https://google.com.tw]>")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

