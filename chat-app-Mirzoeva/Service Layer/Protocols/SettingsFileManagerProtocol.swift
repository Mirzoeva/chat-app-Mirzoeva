//
//  SettingsFileManagerProtocol.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 29.03.2022.
//

import Foundation

protocol SettingsFileManagerProtocol {
    func saveData(user: UserInfo, completion: ((Bool) -> Void)?)
    func readData(completion: @escaping (UserInfo) -> Void)
}
