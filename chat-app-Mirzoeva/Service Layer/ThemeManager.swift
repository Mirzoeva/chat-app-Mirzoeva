//
//  ThemeManager.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 17.03.2022.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

class ThemeManager: ThemesViewControllerDelegate {
    
    static var shared = ThemeManager()
    
    private init() {}
    
    static var currentTheme: Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme) ?? .classic
        } else {
            return .classic
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.titleTextColor
        UINavigationBar.appearance().barStyle = theme.barStyle
    }
    
    func didChooseTheme(_ theme: Theme) {
        ThemeManager.applyTheme(theme: theme)
    }
}
