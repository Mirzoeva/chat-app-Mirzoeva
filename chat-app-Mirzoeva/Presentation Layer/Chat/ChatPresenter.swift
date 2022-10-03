//
//  ChatPresenter.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 01.05.2022.
//

import Foundation
import FirebaseFirestore
import CoreData

protocol ChatPresenter {
    func loadMessages(channelId: String, completion: @escaping ([MessageModel]) -> Void)
    func addMessage(content: String, senderId: String, senderName: String, channelId: String)
}

class ChatPresenterImpl: ChatPresenter {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection(L10n.Firebase.channels)
    private var coreDataStack: CoreDataService
    
    init(coreDataStack: CoreDataService) {
        self.coreDataStack = coreDataStack
    }
    
    func loadMessages(channelId: String, completion: @escaping ([MessageModel]) -> Void) {
        reference.document(channelId)
            .collection(L10n.Firebase.messages)
            .order(by: L10n.CoreData.created, descending: false)
            .addSnapshotListener { [weak self] snap, error in
                guard let snap = snap else { return }
                let messagesData: [MessageModel] = snap.documents.compactMap { document in
                    let dict = document.data()
                    guard
                        let content = dict[L10n.CoreData.content] as? String,
                        let created = (dict[L10n.CoreData.created] as? Timestamp)?.dateValue(),
                        let senderId = dict[L10n.CoreData.senderId] as? String,
                        let senderName = dict[L10n.CoreData.senderName] as? String
                    else { return nil }
                    return MessageModel(
                        content: content,
                        created: created,
                        senderId: senderId,
                        senderName: senderName)
                }
                self?.coreDataStack.performAndSave { context in
                    self?.saveMessagesInCoreData(channelId: channelId, context: context, messages: messagesData)
                }
                completion(messagesData)
            }
    }
    
    private func saveMessagesInCoreData(channelId: String, context: NSManagedObjectContext, messages: [MessageModel]) {
        let channel = coreDataStack.fetchChannel(id: channelId, context: context)
        messages.forEach { message in
            let item = DBMessage(context: context)
            item.content = message.content
            item.created = message.created
            item.senderId = message.senderId
            item.senderName = message.senderName
            channel.addToMessages(item)
        }
    }
    
    func addMessage(content: String, senderId: String, senderName: String, channelId: String) {
        var newMessage: [String: Any] {
            [L10n.CoreData.content: content,
             L10n.CoreData.created: Timestamp(date: Date()),
             L10n.CoreData.senderId: senderId,
             L10n.CoreData.senderName: senderName
            ]
        }
        reference.document(channelId).collection(L10n.Firebase.messages).addDocument(data: newMessage)
    }
}
