//
//  GCDFileManager.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 29.03.2022.
//

import Foundation

class GCDFileManger: SettingsFileManagerProtocol {
    
    private let fileName = "UserData.json"
    
    func saveData(user: UserInfo, completion: ((Bool) -> Void)?) {
        DispatchQueue.global().async {
            self.save(user: user, completion: completion)
        }
    }
    
    func readData(completion: @escaping (UserInfo) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let userInfo = self.readData() ?? UserInfo()
            
            DispatchQueue.main.async {
                completion(userInfo)
            }
        }
    }
    
    private func save(user: UserInfo, completion: ((Bool) -> Void)?) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion?(false)
            return
        }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(user)
            try data.write(to: fileUrl, options: [])
            DispatchQueue.main.async {
                completion?(true)
            }
        } catch {
            DispatchQueue.main.async {
                completion?(false)
            }
        }
    }
    
    private func readData() -> UserInfo? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        
        guard
            let data = try? Data(contentsOf: fileUrl),
            let userData = try? JSONDecoder().decode(UserInfo.self, from: data)
        else {
            return nil
        }
        
        return userData
    }
}
