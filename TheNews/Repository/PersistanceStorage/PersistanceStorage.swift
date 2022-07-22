//
//  PersistanceStorage.swift
//  TheNews
//
//  Created by Dipak Singh on 28/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation
import CoreData

public class PersistenceStorage {
    
    public static let shared = PersistenceStorage()
    private init() {}
    
    public lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    public func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Fetch support
    public func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try
                    PersistenceStorage
                .shared
                .context
                .fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            return result
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
