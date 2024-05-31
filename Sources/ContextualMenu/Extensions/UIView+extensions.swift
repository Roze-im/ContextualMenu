//
//  UIView+extensions.swift
//  
//
//  Created by Thibaud David on 06/02/2023.
//

import Foundation
import UIKit

extension UIView {
    public func addInteraction(
        targetedPreviewProvider: @escaping TargetedPreviewProvider,
        menuConfigurationProvider: @escaping MenuConfigurationProvider,
        style: ContextMenuStyle = .default
    ) {
        ContextMenuInteractor.shared.addInteraction(
            on: self,
            targetedPreviewProvider: targetedPreviewProvider,
            menuConfigurationProvider: menuConfigurationProvider,
            style: style
        )
    }
    public func dismissContextMenu(completion: (() -> Void)? = nil) {
        ContextMenuInteractor.shared.dismissContextMenu(view: self, completion: completion)
    }

    public static func dismissCurrentContextMenu(completion: (() -> Void)? = nil) {
        ContextMenuInteractor.shared.dismissCurrentContextMenu(completion: completion)
    }
}

extension UIView {
    /// Apply a scaling transformation from an anchorPoint
    func applyTransform(scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let xPadding = 1 / scale * (anchorPoint.x - 0.5) * bounds.width
        let yPadding = 1 / scale * (anchorPoint.y - 0.5) * bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
}
