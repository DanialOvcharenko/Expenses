//
//  DataManager.swift
//  Expenses(2.0)
//
//  Created by Mac on 10.03.2023.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpencesModels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //MARK: -
    
    func expenceType(name: String) -> ExpenceType {
        let expenceType = ExpenceType(context: persistentContainer.viewContext)
        expenceType.name = name
        expenceType.total = 0
        return expenceType
    }
    
    func expence(name: String, cost: Float, expenceType: ExpenceType) -> Expence {
        let expence = Expence(context: persistentContainer.viewContext)
        expence.name = name
        expence.cost = cost
        expenceType.addToExpences(expence)
        return expence
    }
    
    func historyExpence(name: String, total: Float) -> HistoryExpence {
        let historyExpence = HistoryExpence(context: persistentContainer.viewContext)
        historyExpence.name = name
        historyExpence.total = total
        return historyExpence
    }
    
    //
    
    //MARK: - Arrays
    
    func expenceTypes() -> [ExpenceType] {
        let request: NSFetchRequest<ExpenceType> = ExpenceType.fetchRequest()
        var fetchedExpenceTypes: [ExpenceType] = []
        
        do {
            fetchedExpenceTypes = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedExpenceTypes
    }
    
    func expences(expenceType: ExpenceType) -> [Expence] {
        let request: NSFetchRequest<Expence> = Expence.fetchRequest()
        request.predicate = NSPredicate(format: "expenceType = %@", expenceType)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        var fetchedExpences: [Expence] = []
        
        do {
            fetchedExpences = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return fetchedExpences
    }
    
    func historyExpences() -> [HistoryExpence] {
        let request: NSFetchRequest<HistoryExpence> = HistoryExpence.fetchRequest()
        var fetchedHistoryExpences: [HistoryExpence] = []
        
        do {
            fetchedHistoryExpences = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedHistoryExpences
    }
    
    //
    
    // MARK: - Core Data Saving support
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteExpence(expense: Expence) {
        let context = persistentContainer.viewContext
        context.delete(expense)
        save()
    }
    
    func deleteExpenceType(expenceType: ExpenceType) {
        let context = persistentContainer.viewContext
        context.delete(expenceType)
        save()
    }
    
    func deleteHistoryExpence(historyExpence: HistoryExpence) {
        let context = persistentContainer.viewContext
        context.delete(historyExpence)
        save()
    }

}
