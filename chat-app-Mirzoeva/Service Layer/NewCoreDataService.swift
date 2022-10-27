//
//  NewCoreDataService.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 12.04.2022.
//

import CoreData
import UIKit

final class NewCoreDataService: CoreDataService {
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                print(storeDescription)
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func fetchChannels() -> [DBChannel] {
        let timeSortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: true)
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [timeSortDescriptor]
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            print(#function)
        }
        return []
    }
    
    func fetchMessages() -> [DBMessage] {
        let timeSortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [timeSortDescriptor]
        do {
           return try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            print(#function)
        }
        return []
    }
    
    func fetchChannel(id: String, context: NSManagedObjectContext?) -> DBChannel {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "identifier = %@", id
        )
        let context = context ?? container.viewContext
        do {
            let channel = try context.fetch(fetchRequest).first ?? DBChannel()
            return channel
        } catch {
            print(error.localizedDescription)
            print(#function)
        }
        return DBChannel()
    }
    
    
    func performAndSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = container.newBackgroundContext()
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                    print(#function)
                }
            }
        }
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                container.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
