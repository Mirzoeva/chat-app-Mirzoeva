//
//  Theme.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 17.03.2022.
//

import UIKit

enum Theme: Int {
    
    case classic, day, night
    
    var title: String {
        switch self {
        case .classic:
            return "Classic"
        case .day:
            return "Day"
        case .night:
            return "Night"
        }
    }
    
    var mainColor: UIColor {
        switch self {
        case .classic:
            return Colors.black.color
        case .day:
            return Colors.rustyRed.color
        case .night:
            return Colors.white.color
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .classic:
            return .default
        case .day:
            return .default
        case .night:
            return .default
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .classic ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .classic ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return Colors.white.color
        case .day:
            return Colors.veryLightPink.color
        case .night:
            return Colors.black.color
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .classic:
            return Colors.upperGray.color
        case .day:
            return Colors.orangeyRed.color
        case .night:
            return Colors.brownGrey.color
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .classic:
            return Colors.black.color
        case .day:
            return Colors.black.color
        case .night:
            return Colors.white.color
        }
    }
    var buttonColor: UIColor {
        switch self {
        case .classic:
            return Colors.yellow.color
        case .day:
            return Colors.yellow.color
        case .night:
            return Colors.rustyRed.color
        }
    }
}
