//
//  NetworkService.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 21.04.2022.
//

import Foundation

protocol NetworkService {
    func loadChannels(completion: @escaping ([ChannelModel]) -> Void)
    func createChannel(name: String, completion: @escaping () -> Void)
    func loadMessages(channel id: String, completion: @escaping ([MessageModel]) -> Void)
    
    func sendMessage(
        channelId: String,
        senderId: String,
        message: String,
        name: String,
        completion: @escaping () -> Void
    )
}
