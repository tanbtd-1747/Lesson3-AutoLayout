//
//  ViewController2.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/21/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, ViewController3Delegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sendBackButtonTapped(data: String) {
        textLabel.text = data
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "twothree" {
            let destVC = segue.destination as! ViewController3
            destVC.dataFromPrevious = textField.text!
            destVC.delegate = self
            destVC.closure = {
                [weak self] data in
                self?.textLabel.text = data
            }
        }
    }
    
    @IBAction func unwindToViewController2(from segue: UIStoryboardSegue) {
        if segue.source is ViewController3 {
            let srcVc = segue.source as! ViewController3
            textLabel.text = srcVc.dataToSendBack
        }
    }

}
