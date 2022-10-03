//
//  MessageViewCell.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import Foundation
import UIKit

class MessageViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var model: MessageModel? {
        didSet {
            guard let model = model else {
                return
            }
            textlabel.text = model.content
            authorName.text = model.senderName
            var fromMe = false
            if (model.senderId != UserInfoManager.shared.getSenderId()) {
                fromMe = true
            }
            incomingConstraint?.isActive = fromMe
            outcomingConstraint?.isActive = !fromMe
            if fromMe {
                contentView.backgroundColor = ThemeManager.currentTheme.backgroundColor
            } else {
                authorName.isHidden = true
                contentView.backgroundColor = ThemeManager.currentTheme.secondaryColor
            }
        }
    }
    
    private var incomingConstraint: NSLayoutConstraint?
    private var outcomingConstraint: NSLayoutConstraint?
    
    private lazy var textlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var authorName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textlabel.textColor = ThemeManager.currentTheme.titleTextColor
        guard let model = model else { return }
        if model.senderId != UserInfoManager.shared.getSenderId() {
            contentView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        } else {
            authorName.isHidden = true
            contentView.backgroundColor = ThemeManager.currentTheme.secondaryColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
    // MARK: - SetupLayout
    
    private func setupLayout() {
        [textlabel, authorName].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        contentView.tintColor = ThemeManager.currentTheme.secondaryColor
        incomingConstraint = textlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7)
        incomingConstraint?.priority =  UILayoutPriority(1000)
        outcomingConstraint = textlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        outcomingConstraint?.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            authorName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            authorName.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            textlabel.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: 7),
            textlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            textlabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75)
        ])
    }
}
