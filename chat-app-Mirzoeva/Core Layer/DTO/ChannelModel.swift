//
//  ChannelModel.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import Foundation
import UIKit

struct ChannelModel: Codable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity ?? Date()
     }
}
