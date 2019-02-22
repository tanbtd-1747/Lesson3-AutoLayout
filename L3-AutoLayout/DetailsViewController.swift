//
//  DetailsViewController.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/22/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var lblUniversity: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = person.name
        lblUniversity.text = person.university
        lblDescription.text = person.desc
        
        lblDescription.numberOfLines = 0
    }

}
