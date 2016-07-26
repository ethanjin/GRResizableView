//
//  ViewController.swift
//  GRResizableView
//
//  Created by Ethan Jin on 7/26/16.
//  Copyright © 2016 EthanJin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let resizableView = GRResizableView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        self.view.addSubview(resizableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

