//
//  ChatProfileImageView.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 08.10.2022.
//

import UIKit

class ChatProfileImageView: UIImageView {
    let placeholderImage = L10n.Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: 240),
                heightAnchor.constraint(equalToConstant: 240)
        ])
    }
}
