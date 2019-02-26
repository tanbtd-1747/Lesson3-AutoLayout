//
//  Person+CoreDataProperties.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/26/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//
//

import Foundation
import CoreData

extension Person {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var city: String
    @NSManaged public var name: String

}
