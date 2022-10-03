//
//  SenderBuilder.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 07.04.2022.
//

import Foundation

class UserInfoManager {
    
    static let shared = UserInfoManager()
    private let settingsFileManager = GCDFileManger()
    
    private init () {
        configureSenderId()
    }
    
    private func configureSenderId() {
        let uuid = UUID().uuidString
        if getSenderId() == nil {
            UserDefaults.standard.setValue(uuid, forKey: Key.senderId.rawValue)
        }
    }
    
    func getSenderId() -> String? {
        return UserDefaults.standard.value(forKey: Key.senderId.rawValue) as? String
    }
    
    func getUserInfo(completion: @escaping (UserInfo) -> Void) {
        settingsFileManager.readData(completion: completion)
    }
    
    enum Key: String {
        case senderId
    }
}

