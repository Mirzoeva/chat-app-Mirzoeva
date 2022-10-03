//
//  CoreDataService.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 21.04.2022.
//

import CoreData

protocol CoreDataService {
    var context: NSManagedObjectContext { get }
    func fetchChannels() -> [DBChannel]
    func fetchMessages() -> [DBMessage]
    func performAndSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func fetchChannel(id: String, context: NSManagedObjectContext?) -> DBChannel
}
