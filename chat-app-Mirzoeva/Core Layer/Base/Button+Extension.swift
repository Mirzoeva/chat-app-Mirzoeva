//
//  Button+Extension.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 04.05.2022.
//

import Foundation
import UIKit

extension UIButton {
    
    func shaking() {
        let shaking = CAKeyframeAnimation(keyPath: "position")
        let newPosition1 = CGPoint(x: center.x, y: center.y + 5)
        let newPosition2 = CGPoint(x: center.x, y: center.y - 5)
        let newPosition3 = CGPoint(x: center.x - 5, y: center.y)
        let newPosition4 = CGPoint(x: center.x + 5, y: center.y)
        shaking.values = [CGPoint(x: center.x, y: center.y),
                                newPosition1,
                                newPosition2,
                                newPosition3,
                                newPosition4]
        
        let rotateMove = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateMove.fromValue = -Double.pi/20
        rotateMove.toValue = Double.pi/20
        rotateMove.isCumulative = true
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.autoreverses = true
        group.repeatCount = .infinity
        group.isRemovedOnCompletion = false
        group.fillMode = .both
        group.animations = [shaking, rotateMove]
        
        layer.add(group, forKey: nil)
    }
    
    func stopShaking() {
        layer.removeAllAnimations()
    }
}
