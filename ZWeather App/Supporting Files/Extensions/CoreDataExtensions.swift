//
//  CoreDataExtemsions.swift
//  ZWeather App
//
//  Created by Dinesh G on 01/01/24.
//

import UIKit
import CoreData


extension NSManagedObject{
    static func getLocalData<T : NSManagedObject>(
        context : NSManagedObjectContext = ZCoreDataStack.shared.storeContainer.viewContext ,
        predicate : NSPredicate? = nil ,
        sortDescriptor : [NSSortDescriptor]? = nil
    ) -> [T]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(self))
        if let predicate = predicate{
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor{
            request.sortDescriptors = sortDescriptor
        }
        return (try? context.fetch(request)) as? [T] ?? []
    }
    static func deleteDataFromLocal(context : NSManagedObjectContext = ZCoreDataStack.shared.storeContainer.viewContext , predicate : NSPredicate? = nil){
        let data = getLocalData(context: context , predicate: predicate)
        data.forEach{ context.delete($0)}
        context.saveContext()
    }
}

extension NSManagedObjectContext{
    func saveContext(){
        guard self.hasChanges else { return }
        
        do {
            try self.save()
        } catch {
            print(error)
        }
    }
}
