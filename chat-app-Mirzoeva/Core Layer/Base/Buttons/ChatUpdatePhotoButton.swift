//
//  ChatUpdatePhotoButton.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 09.10.2022.
//

import UIKit

class ChatUpdatePhotoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        setTitle(L10n.change, for: .normal)
    }
}
