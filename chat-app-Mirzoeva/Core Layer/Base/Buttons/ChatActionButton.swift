//
//  ChatActionButton.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 27.10.2022.
//

import UIKit

class ChatActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
        layer.cornerRadius = 14
        layer.masksToBounds = true
    }
}
