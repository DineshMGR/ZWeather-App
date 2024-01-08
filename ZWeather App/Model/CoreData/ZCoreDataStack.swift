//
//  ZCoreDataStack.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import CoreData

final class ZCoreDataStack{
    static let shared = ZCoreDataStack(modelName: "ZWeather_App")
    private var modelName: String!
    
    private init(modelName : String) {
        self.modelName = modelName
    }
    
    private(set) lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Core Data Saving support
    /// Function to save changes in main context
    func saveContext () {
        guard storeContainer.viewContext.hasChanges else { return }
        
        do {
            try storeContainer.viewContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
