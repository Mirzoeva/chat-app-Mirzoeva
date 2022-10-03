//
//  ChannelsPresenter.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 01.05.2022.
//

import Foundation
import FirebaseFirestore
import CoreData

protocol ChannelsPresenter {
    func loadChats(completion: @escaping ([ChannelModel]) -> Void)
    func addChannel(channelName: String?)
}

class ChannelsPresenterImpl: ChannelsPresenter {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection(L10n.Firebase.channels)
    private var coreDataStack: CoreDataService
    
    init(coreDataStack: CoreDataService) {
        self.coreDataStack = coreDataStack
    }
    
    func loadChats(completion: @escaping ([ChannelModel]) -> Void) {
        reference.order(by: L10n.CoreData.lastActivity, descending: false)
            .addSnapshotListener { [weak self] snap, error in
                guard let snap = snap else { return }
                let channels: [ChannelModel] = snap.documents.compactMap { document in
                    let dict = document.data()
                    guard let name = dict["name"] as? String else { return nil }
                    return ChannelModel(
                        identifier: document.documentID,
                        name: name,
                        lastMessage: dict["lastMessage"] as? String,
                        lastActivity: (dict["lastActivity"] as? Timestamp)?.dateValue()
                    )
                }
                self?.coreDataStack.performAndSave { context in
                    self?.saveChannelsInCoreData(context: context, channels: channels)
                }
                completion(channels)
            }
    }
    
    func addChannel(channelName: String?) {
        var newChannel: [String: Any] {
            [L10n.CoreData.name: channelName ?? L10n.unknownChannelName]
        }
        DispatchQueue.main.async {
            self.reference.addDocument(data: newChannel)
        }
    }
    
    private func saveChannelsInCoreData(context: NSManagedObjectContext, channels: [ChannelModel]) {
        channels.forEach { chatSection in
            let item = DBChannel(context: context)
            item.name = chatSection.name
            item.lastActivity = chatSection.lastActivity
            item.identifier = chatSection.identifier
            item.lastMessage = chatSection.lastMessage
        }
    }
    
}
