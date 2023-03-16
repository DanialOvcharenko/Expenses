//
//  ExpenceType+CoreDataProperties.swift
//  Expenses(2.0)
//
//  Created by Mac on 10.03.2023.
//
//

import Foundation
import CoreData


extension ExpenceType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenceType> {
        return NSFetchRequest<ExpenceType>(entityName: "ExpenceType")
    }

    @NSManaged public var name: String?
    @NSManaged public var total: Float
    @NSManaged public var expences: NSSet?

}

// MARK: Generated accessors for expences
extension ExpenceType {

    @objc(addExpencesObject:)
    @NSManaged public func addToExpences(_ value: Expence)

    @objc(removeExpencesObject:)
    @NSManaged public func removeFromExpences(_ value: Expence)

    @objc(addExpences:)
    @NSManaged public func addToExpences(_ values: NSSet)

    @objc(removeExpences:)
    @NSManaged public func removeFromExpences(_ values: NSSet)

}

extension ExpenceType : Identifiable {

}
