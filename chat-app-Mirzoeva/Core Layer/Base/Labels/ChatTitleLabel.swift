//
//  ChatTitleLabel.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 07.10.2022.
//

import UIKit

class ChatTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTheme(theme: Theme) {
        textColor = theme.secondaryColor
        configure()
    }
    
    private func configure(){
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
