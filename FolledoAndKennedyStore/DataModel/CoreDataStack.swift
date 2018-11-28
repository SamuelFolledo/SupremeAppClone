//
//  CoreDataStack.swift
//  PirateBay
//
//  Created by Andi Setiyadi on 11/16/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack { //PB ep8
    lazy var persistentContainer: NSPersistentContainer = { //PB ep 8
        let container = NSPersistentContainer(name: "StoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () { //PB ep8
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
