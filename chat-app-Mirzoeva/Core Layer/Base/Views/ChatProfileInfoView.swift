//
//  ChatProfileInfoView.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 08.10.2022.
//

import UIKit

class ChatProfileInfoView: UIView {
    let usernameTextField = ChatTextField()
    let userInfoTextField = ChatTextField()
    
    var isEditing = false {
        didSet {
            if isEditing {
                [userInfoTextField, usernameTextField].forEach {
                    $0.isUserInteractionEnabled = true
                }
                usernameTextField.becomeFirstResponder()
            }
            else {
                [userInfoTextField, usernameTextField].forEach {
                    $0.isUserInteractionEnabled = false
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [usernameTextField, userInfoTextField].forEach {
            addSubview($0)
            translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = ThemeManager.currentTheme.titleTextColor
        }
        
        usernameTextField.font = .systemFont(ofSize: 20, weight: .regular)
        usernameTextField.autocapitalizationType = .words
        usernameTextField.textAlignment = .center
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.TextFieldPlaceholders.name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
        )
        
        userInfoTextField.font = .systemFont(ofSize: 16, weight: .regular)
        userInfoTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.TextFieldPlaceholders.status,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
        )
        
        configureLayoutConstraints()
        
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate(
            [
                usernameTextField.topAnchor.constraint(equalTo: topAnchor),
                usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
                usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
                usernameTextField.heightAnchor.constraint(equalToConstant: 30),
                
                userInfoTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
                userInfoTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
                userInfoTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
                userInfoTextField.heightAnchor.constraint(equalToConstant: 30)
            ]
        )
    }
    
}
