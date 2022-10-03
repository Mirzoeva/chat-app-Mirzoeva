//
//  Logger.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 23.02.2022.
//

import Foundation

enum Logger {
    private static var showLog = false
    
    static func fullLog(from startState: String, to finishState: String, function: String) {
        if (showLog == true) {
            print("Application moved from \(startState) to \(finishState): \(function)")
        }
    }
    
    static func log(function: String) {
        if (showLog == true) {
            print(function)
        }
    }
}
