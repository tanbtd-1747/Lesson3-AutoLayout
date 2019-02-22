//
//  Person.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/22/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import Foundation

struct Person {
    var name: String
    var university: String
    var desc: String
    
    init() {
        name = ""
        university = ""
        desc = ""
    }
    
    init(name: String, university: String, desc: String) {
        self.name = name
        self.university = university
        self.desc = desc
    }
}
