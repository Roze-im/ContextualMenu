//
//  MenuView+Animations.swift
//  
//
//  Created by Thibaud David on 21/02/2023.
//

import Foundation
import UIKit

extension MenuView: ContextMenuAnimatable {
    public func appearAnimation(completion: (() -> Void)? = nil) {
        applyTransform(
            scale: style.disappearedScalingValue,
            anchorPoint: anchorPointAlignment == .leading ? .zero : .init(x: 1, y: 0)
        )
        alpha = 0
        UIView.animate(
            withDuration: style.disapparition.duration,
            delay: 0,
            usingSpringWithDamping: style.disapparition.damping,
            initialSpringVelocity: style.disapparition.initialSpringVelocity,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                self.alpha = 1
                self.applyTransform(
                    scale: 1,
                    anchorPoint: self.anchorPointAlignment == .leading ? .zero : .init(x: 1, y: 0)
                )
            },
            completion: { _ in
                completion?()
            }
        )
    }
    public func disappearAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: style.disapparition.duration,
            delay: 0,
            usingSpringWithDamping: style.disapparition.damping,
            initialSpringVelocity: style.disapparition.initialSpringVelocity,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                self.alpha = 0
                self.applyTransform(
                    scale: self.style.disappearedScalingValue,
                    anchorPoint: self.anchorPointAlignment == .leading ? .zero : .init(x: 1, y: 0)
                )
            },
            completion: { _ in
                completion?()
            }
        )
    }
}
