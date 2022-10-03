//
//  NewCoreDataService.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 12.04.2022.
//

import CoreData

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
                }
            }
        }
    }
}
