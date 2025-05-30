//
//  ContextMenuViewController+Animations.swift
//  
//
//  Created by Thibaud David on 21/02/2023.
//

import Foundation
import UIKit

// Animations completion closure is called once preview animation is done.
// Depending on your animation parameters for Menu / AccessoryView,
// completion might be called before all animations are done.
// In the future, we might consider synchronizing all animations if needed
// using keyframes animations
// ETA: "Flemme 🥖"©
extension ContextMenuViewController: ContextMenuAnimatable {
    public func appearAnimation(completion: (() -> Void)? = nil) {
        NSLayoutConstraint.activate(constraintsAlteringPreviewPosition)
        view.setNeedsLayout()
        
        previewRendering.layer.applyShadow(style.preview.shadow, overrideOpacity: 0)
        
        previewRendering.layer.animate(
            keyPath: \.shadowOpacity,
            toValue: style.preview.shadow.opacity,
            duration: style.apparition.duration
        )

        menuView?.appearAnimation()

        if let animatableAccessoryView {
            animatableAccessoryView.appearAnimation()
        } else {
            accessoryView?.alpha = 0
        }

        UIView.animate(
            withDuration: style.apparition.duration,
            delay: 0,
            usingSpringWithDamping: style.apparition.damping,
            initialSpringVelocity: style.apparition.initialSpringVelocity,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                self.view.layoutIfNeeded()
                self.backgroundBlur.alpha = self.style.blurAlpha
                // Apply transform to previewRendering
                let transform = self.style.preview.transform
                self.previewRendering.transform = transform

                if self.animatableAccessoryView == nil {
                    // Perform a default fadin animation if needed
                    self.accessoryView?.alpha = 1
                }
            },
            completion: { _ in completion?() }
        )
        
    }
    public func disappearAnimation(completion: (() -> Void)? = nil) {
        NSLayoutConstraint.deactivate(constraintsAlteringPreviewPosition)
        view.setNeedsLayout()

        // Restore original view's alpha in sync with animation
        // Using below animation completion block causes a slight flickering sometimes
        if let originalView = targetedPreview?.view {
            UIView.animate(
                withDuration: style.disapparition.duration,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: {
                    originalView.alpha = 1
                },
                completion: nil
            )
        }

        // Ensure shadow on previewRendering disappears correctly
        previewRendering.layer.animate(
            keyPath: \.shadowOpacity,
            toValue: 0,
            duration: style.disapparition.duration 
        )

        menuView?.disappearAnimation()
        animatableAccessoryView?.disappearAnimation()

        UIView.animate(
            withDuration: style.disapparition.duration,
            delay: 0,
            usingSpringWithDamping: style.disapparition.damping,
            initialSpringVelocity: style.disapparition.initialSpringVelocity,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                self.view.layoutIfNeeded()
                self.backgroundBlur.alpha = 0
                // Apply transform to previewRendering
                self.previewRendering.transform = .identity
                
                if self.animatableAccessoryView == nil {
                    // Perform a default fadout animation if needed
                    self.accessoryView?.alpha = 0
                }
            },
            completion: { [weak self] _ in
                // Don't modify alpha here anymore since we handle it in the synchronized animation above
                // targetedPreview might be retaining views. Nullifying it to break any potential retain cycle
                self?.targetedPreview = nil
                completion?()
            }
        )
    }
}
