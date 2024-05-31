//
//  NSLayoutConstraint+Priority.swift
//  
//
//  Created by Thibaud David on 09/02/2023.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func priority(_ prioriry: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = prioriry
        return self
    }

    static func keeping(view: UIView, insideFrameOf contentView: UIView) -> [NSLayoutConstraint] {
        return [
            // Keep accessory view above view top
            view.topAnchor.constraint(
                greaterThanOrEqualToSystemSpacingBelow: contentView.safeAreaLayoutGuide.topAnchor, multiplier: 1
            ),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(
                greaterThanOrEqualToSystemSpacingBelow: view.bottomAnchor, multiplier: 1
            ),
            // Keep accessoryView between leading & trailing edges
            view.leadingAnchor.constraint(
                greaterThanOrEqualToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1
            ),
            contentView.trailingAnchor.constraint(
                greaterThanOrEqualToSystemSpacingAfter: view.trailingAnchor, multiplier: 1
            )
        ]
    }
}
