//
//  NetworkServiceImpl.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 21.04.2022.
//

import FirebaseFirestore

class NetworkServiceImpl: NetworkService {
    
    private let db = Firestore.firestore()
    private lazy var reference = db.collection(L10n.Firebase.channels)
    
    func loadChannels(completion: @escaping ([ChannelModel]) -> Void) {
        reference
            .order(by: L10n.CoreData.lastActivity, descending: false)
            .addSnapshotListener { snap, error in
                guard let snap = snap else {
                    completion([])
                    return
                }
                let channels: [ChannelModel] = snap.documents.compactMap { document in
                    let dict = document.data()
                    guard let name = dict[L10n.CoreData.name] as? String else {
                        return nil
                    }
                    return ChannelModel(
                        identifier: document.documentID,
                        name: name,
                        lastMessage: dict[L10n.CoreData.lastMessage] as? String,
                        lastActivity: (dict[L10n.CoreData.lastActivity] as? Timestamp)?.dateValue()
                    )
                }
                completion(channels)
            }
    }
    
    func createChannel(name: String, completion: @escaping () -> Void) {
        reference.addDocument(data: [L10n.CoreData.name: name])
        completion()
    }
    
    func loadMessages(channel id: String, completion: @escaping ([MessageModel]) -> Void) {
        reference
            .document(id)
            .collection(L10n.Firebase.messages)
            .order(by: L10n.CoreData.created, descending: false)
            .addSnapshotListener { snap, error in
                guard let snap = snap else {
                    completion([])
                    return
                }
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
                completion(messagesData)
            }
    }
    
    func sendMessage(
        channelId: String,
        senderId: String,
        message: String,
        name: String,
        completion: @escaping () -> Void
    ) {
        let newMessage: [String: Any] = [
            L10n.CoreData.content: message,
            L10n.CoreData.created: Timestamp(date: Date()),
            L10n.CoreData.senderId: senderId,
            L10n.CoreData.name: name
        ]
        reference
            .document(channelId)
            .collection(L10n.Firebase.messages)
            .addDocument(data: newMessage)
        
        completion()
    }
}
