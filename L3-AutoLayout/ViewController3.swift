//
//  ViewController3.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/21/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var backTextLabel: UILabel!
    
    var dataFromPrevious = ""
    var dataToSendBack = ""
    
    var delegate: ViewController3Delegate?
    var closure: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataToSendBack = "Send back " + dataFromPrevious
        textLabel.text = dataFromPrevious
        backTextLabel.text = dataToSendBack
    }

    @IBAction func onSendBackButtonDelegateTapped(_ sender: Any) {
        delegate?.sendBackButtonTapped(data: dataToSendBack)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSendBackButtonClosureTapped(_ sender: Any) {
        closure?(dataToSendBack)
        navigationController?.popViewController(animated: true)
    }
}

protocol ViewController3Delegate {
    func sendBackButtonTapped(data: String)
}
