//
//  AnimationParameters.swift
//  
//
//  Created by Thibaud David on 16/02/2023.
//

import Foundation
import UIKit

public struct AnimationParameters {
    public let duration: TimeInterval
    public let damping: CGFloat
    public let initialSpringVelocity: CGFloat
    public let curve: UIView.AnimationOptions

    public init(
        duration: TimeInterval = 0.3,
        damping: CGFloat = 1,
        initialSpringVelocity: CGFloat = 4,
        curve: UIView.AnimationOptions = .curveEaseIn
    ) {
        self.duration = duration
        self.damping = damping
        self.initialSpringVelocity = initialSpringVelocity
        self.curve = curve
    }
}
