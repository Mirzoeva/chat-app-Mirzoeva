//
//  ChatButton.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 07.10.2022.
//

import UIKit

class ChatThemesButton: UIButton {
    var theme: Theme = Theme.classic
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTheme(with: Theme) {
        theme = with
        configure()
    }
    
    private func configure() {
        backgroundColor = theme.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
    }
}
