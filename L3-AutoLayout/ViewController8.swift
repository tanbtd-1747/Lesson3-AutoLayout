//
//  ViewController8.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/21/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController8: UIViewController, CustomView8Protocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! CustomView8).delegate = self
    }
    
    func nextButtonTapped() {
        performSegue(withIdentifier: "eighttwo", sender: nil)
    }

}
