//
//  CALayer+extensions.swift
//  
//
//  Created by Thibaud David on 16/02/2023.
//

import Foundation
import UIKit

extension CALayer {
    public func animate<Value>(
        keyPath: WritableKeyPath<CALayer, Value>, toValue: Float, duration: TimeInterval
    ) {
        let keyString = NSExpression(forKeyPath: keyPath).keyPath
        let animation = CABasicAnimation(keyPath: keyString)
        animation.fromValue = shadowOpacity
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        add(animation, forKey: animation.keyPath)
    }

    func applyShadow(_ parameters: ShadowParameters, overrideOpacity: Float? = nil) {
        shadowColor = parameters.color
        shadowOffset = parameters.offset
        shadowRadius = parameters.radius
        shadowOpacity = overrideOpacity ?? parameters.opacity
    }
}
