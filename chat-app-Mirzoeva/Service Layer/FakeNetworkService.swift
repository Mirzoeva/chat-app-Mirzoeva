//
//  FakeNetworkService.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import UIKit
import Foundation

enum RandomMessage: String, CaseIterable {
    case message1 = "Cubilia dictum condimentum habitant lorem habitasse non massa curae penatibus, elit risus vivamus per auctor platea a taciti facilisis, ipsum mollis ridiculus tortor orci senectus mus aliquam."
    case message2 = "Finibus tempus porttitor quis nascetur inceptos himenaeos erat lorem morbi, sollicitudin vestibulum venenatis malesuada consequat accumsan massa hendrerit ullamcorper quisque, viverra tortor maecenas dictumst bibendum vivamus habitasse pulvinar."
    case message3 = "At donec curae pulvinar mus sociosqu elit nullam erat, habitant mauris pretium et lacus lorem ultrices mollis, arcu non nibh tristique aliquet diam class."
    case message4 = "Lobortis aliquam ipsum consequat parturient efficitur nostra cubilia netus tempus, suscipit vestibulum donec malesuada phasellus pellentesque laoreet nascetur tristique viverra, penatibus tempor erat nisi quis nulla ultricies sapien."
    case message5 = "Vehicula fermentum viverra luctus pellentesque neque turpis mollis fames netus diam tincidunt, euismod ultrices senectus tortor interdum dictum ipsum integer praesent molestie ullamcorper amet, per hac platea urna mauris et curae malesuada porttitor blandit."
    case message6 = "Habitant fusce lectus cras scelerisque ullamcorper nisi pharetra, odio ligula blandit porttitor velit eleifend nascetur aenean, a porta consectetur pellentesque mollis diam."
    case message7 = "Pulvinar euismod et natoque tellus curabitur interdum aenean pretium erat a mauris, tortor vitae ac vivamus sit urna porta malesuada lacus."
    case message8 = "Dui suscipit donec cursus vestibulum ridiculus quisque neque sodales aptent, posuere id nam scelerisque nullam nisi inceptos montes quis ad, dolor molestie tristique proin feugiat himenaeos sociosqu platea."
    case message9 = "Platea pellentesque suspendisse feugiat mauris venenatis neque, lacinia ipsum viverra amet class blandit mus, molestie nec pretium cras eros."
    case message10 = ""

    static var get: String {
        return allCases.randomElement()!.rawValue
    }
}

enum RandomName: String, CaseIterable {
    case name1 = "Geraldine Ross"
    case name2 = "Albert Smith"
    case name3 = "Charlotte Porter"
    case name4 = "Pamela Rice"
    case name5 = "Melissa Hardy"
    case name6 = "Robert Burke"
    case name7 = "Grace Green"
    case name8 = "Jose Atkins"
    case name9 = "Tammy Fowler"
    case name10 = "Terri Bryan"

    static var get: String {
        return allCases.randomElement()!.rawValue
    }
}

class FakeNetworkService {
    func loadChats() -> [ChannelModel] {
        var chats = [ChannelModel]()
        let dates = [Date(timeIntervalSinceNow: -1.0),
                     Date(timeIntervalSinceNow: -2.0),
                     Date(timeIntervalSinceNow: -3.0),
                     Date(timeIntervalSinceReferenceDate: -123.0),
                     Date(timeIntervalSinceReferenceDate: -50.0),
                     Date(timeIntervalSinceReferenceDate: -13.0),
                     Date(timeIntervalSinceReferenceDate: -14.0)]
        for _ in 1...30 {
            let chat = ChannelModel(
                identifier: "Fake",
                name: RandomName.get,
                lastMessage: RandomMessage.get,
                lastActivity: dates.randomElement()
            )
            chats.append(chat)
        }
        return chats
    }
    
    func loadMessages() -> [MessageModel] {
        var messages = [MessageModel]()
        let dates = [Date(timeIntervalSinceNow: -1.0),
                     Date(timeIntervalSinceNow: -2.0),
                     Date(timeIntervalSinceNow: -3.0),
                     Date(timeIntervalSinceReferenceDate: -123.0),
                     Date(timeIntervalSinceReferenceDate: -50.0),
                     Date(timeIntervalSinceReferenceDate: -13.0),
                     Date(timeIntervalSinceReferenceDate: -14.0)]
        for _ in 1...10 {
            let message = MessageModel(
                content: RandomMessage.get,
                created: dates.randomElement() ?? Date(timeIntervalSinceNow: -1.0),
                senderId: "Fake",
                senderName: RandomName.get)
            messages.append(message)
        }
        return messages
    }
    
}
