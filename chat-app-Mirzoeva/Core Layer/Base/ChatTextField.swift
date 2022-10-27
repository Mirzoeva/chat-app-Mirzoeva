//
//  ChatTextField.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 07.10.2022.
//

import UIKit

class ChatTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = ThemeManager.currentTheme.mainColor.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        returnKeyType = .go
        clearButtonMode = .whileEditing
    }
}
