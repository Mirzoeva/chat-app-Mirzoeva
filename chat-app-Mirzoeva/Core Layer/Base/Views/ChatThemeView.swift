//
//  ChatThemeView.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 07.10.2022.
//

import UIKit

class ChatThemeView: UIView {
    let themeLabel = ChatTitleLabel()
    let button = ChatThemesButton()
    
    var isChosen = false {
        didSet {
            if isChosen { button.layer.borderColor = UIColor.green.cgColor }
            else { button.layer.borderColor = UIColor.black.cgColor }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with: Theme) {
        self.init(frame: .zero)
        themeLabel.text = with.title
        themeLabel.setTheme(theme: with)
        button.setTheme(with: with)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isChosen { button.layer.borderColor = UIColor.green.cgColor }
        else { button.layer.borderColor = UIColor.black.cgColor }
    }
    
    private func configure() {
        [themeLabel, button].forEach {
            addSubview($0)
        }
        configureLayoutConstraints()
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate(
            [
                button.heightAnchor.constraint(equalToConstant: 50),
                button.topAnchor.constraint(equalTo: topAnchor),
                button.leadingAnchor.constraint(equalTo: leadingAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor),
                themeLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
                themeLabel.heightAnchor.constraint(equalToConstant: 25),
                themeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                themeLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
}
