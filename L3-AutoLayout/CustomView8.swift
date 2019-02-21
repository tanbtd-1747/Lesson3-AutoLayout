//
//  CustomView8.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/21/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class CustomView8: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var button: UIButton!
    
    var delegate: CustomView8Protocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = Bundle.main.loadNibNamed("CustomView8", owner: self, options: nil)?[0] as! UIView
        addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.addTarget(self, action: #selector(onNextScreenButtonTapped), for: .touchUpInside)
    }
    
    @objc func onNextScreenButtonTapped() {
        delegate?.nextButtonTapped()
    }

}

protocol CustomView8Protocol {
    func nextButtonTapped()
}
