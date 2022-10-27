//
//  ChatEmitterCell.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 27.10.2022.
//

import UIKit

class ChatEmitterCell: CAEmitterCell {
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contents = UIImage(named: "tinkoff_logo")?.cgImage
        scale = 0.01
        scaleRange = 0.01
        emissionRange = .pi
        lifetime = 20.0
        birthRate = 20
        velocity = -30
        yAcceleration = 30
        xAcceleration = 5
        spin = -0.5
        spinRange = 1.0
    }
}
