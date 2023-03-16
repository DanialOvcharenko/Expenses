//
//  Expence+CoreDataProperties.swift
//  Expenses(2.0)
//
//  Created by Mac on 10.03.2023.
//
//

import Foundation
import CoreData


extension Expence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expence> {
        return NSFetchRequest<Expence>(entityName: "Expence")
    }

    @NSManaged public var cost: Float
    @NSManaged public var name: String?
    @NSManaged public var expenceType: ExpenceType?

}

extension Expence : Identifiable {

}
