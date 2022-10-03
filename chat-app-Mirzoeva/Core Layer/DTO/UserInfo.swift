//
//  UserInfo.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 03.04.2022.
//

import Foundation
import UIKit

struct UserInfo: Codable {
    var name: String?
    var description: String?
    var imageData: Data? = nil
}
