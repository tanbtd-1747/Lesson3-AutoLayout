//
//  CustomTableViewCell.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/21/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblUniversity: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for person: Person) {
        lblName.text = person.name
        lblUniversity.text = person.university
        lblDescription.text = person.desc
    }
    
}
