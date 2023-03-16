//
//  HistoryExpence+CoreDataProperties.swift
//  Expenses(2.0)
//
//  Created by Mac on 10.03.2023.
//
//

import Foundation
import CoreData


extension HistoryExpence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryExpence> {
        return NSFetchRequest<HistoryExpence>(entityName: "HistoryExpence")
    }

    @NSManaged public var name: String?
    @NSManaged public var total: Float

}

extension HistoryExpence : Identifiable {

}
