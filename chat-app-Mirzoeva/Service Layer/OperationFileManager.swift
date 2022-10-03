//
//  OperationFileManagere.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 29.03.2022.
//

import Foundation

class OperationFileManager: SettingsFileManagerProtocol {
    
    private let fileName = "UserData.json"
    
    func saveData(user: UserInfo, completion: ((Bool) -> Void)?) {
        let queue = OperationQueue()
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion?(false)
            return
        }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        
        queue.addOperation(
            OwnOperation(
                fileUrl: fileUrl,
                userData: user,
                completion: completion
            )
        )
    }
    
    func readData(completion: @escaping (UserInfo) -> Void) {
//        Operation
    }
}


class OwnOperation: Operation {
    
    private let fileUrl: URL
    private let userData: UserInfo
    private let completion: ((Bool) -> Void)?

    init(
        fileUrl: URL,
        userData: UserInfo,
        completion: ((Bool) -> Void)?
    ) {
        self.fileUrl = fileUrl
        self.userData = userData
        self.completion = completion
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        do {
            let data = try JSONEncoder().encode(userData)
            try data.write(to: fileUrl, options: [])
            DispatchQueue.main.async {
                self.completion?(true)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.completion?(false)
            }
        }
    }
}
