//
//  MessageModel.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import Foundation

import UIKit

class MessageModel {
    var content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
     }
}
