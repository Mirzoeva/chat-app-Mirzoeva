//
//  ChatsViewCell.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import UIKit

class ChannelViewCell: UITableViewCell {
    private let dateFormatter = DateFormatter()
    
    var model: ChannelModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.name
            
            if (model.lastMessage != nil && model.lastMessage != "")  {
                messageLabel.text = model.lastMessage
            } else {
                messageLabel.text = "No messages yet"
                messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            }
            
            if (Calendar.current.isDateInToday(model.lastActivity)) {
                dateFormatter.dateFormat = "HH:mm"
                dateLabel.text = dateFormatter.string(from: model.lastActivity)
            } else {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateLabel.text = dateFormatter.string(from: model.lastActivity)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.textColor = ThemeManager.currentTheme.titleTextColor
        messageLabel.textColor = ThemeManager.currentTheme.titleTextColor
        dateLabel.textColor = ThemeManager.currentTheme.buttonColor
    }
    
    // MARK: - Private

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private func setupLayout() {
        [nameLabel, messageLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: NSLayoutConstraint.Axis.vertical)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
