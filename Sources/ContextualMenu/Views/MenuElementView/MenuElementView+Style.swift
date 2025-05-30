//
//  MenuElementView+Style.swift
//  
//
//  Created by Thibaud David on 17/02/2023.
//

import Foundation
import UIKit

extension MenuElementView {
    public struct Style {
        let height: CGFloat

        let backgroundColor: UIColor
        let highlightedBackgroundColor: UIColor

        let defaultTitleAttributes: [NSAttributedString.Key: Any]
        let destructiveTitleAttributes: [NSAttributedString.Key: Any]

        let defaultIconTint: UIColor
        let destructiveIconTint: UIColor
        let iconSize: CGSize

        public init(
            height: CGFloat = 41.5,
            backgroundColor: UIColor = .clear,
            highlightedBackgroundColor: UIColor = .systemGray4,
            defaultTitleAttributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.label
            ],
            destructiveTitleAttributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.systemRed
            ],
            defaultIconTint: UIColor = .label,
            destructiveIconTint: UIColor = .systemRed,
            iconSize: CGSize = .init(width: 20, height: 20)
        ) {
            self.height = height
            self.backgroundColor = backgroundColor
            self.highlightedBackgroundColor = highlightedBackgroundColor
            self.defaultTitleAttributes = defaultTitleAttributes
            self.destructiveTitleAttributes = destructiveTitleAttributes
            self.defaultIconTint = defaultIconTint
            self.destructiveIconTint = destructiveIconTint
            self.iconSize = iconSize
        }
    }

    internal static func titleAttributes(
        attributes: MenuElement.Attributes,
        style: MenuElementView.Style
    ) -> [NSAttributedString.Key: Any] {
        switch attributes {
        case .destructive: return style.destructiveTitleAttributes
        default:
            return style.defaultTitleAttributes
        }
    }

    internal static func iconTint(
        attributes: MenuElement.Attributes,
        style: MenuElementView.Style
    ) -> UIColor {
        switch attributes {
        case .destructive: return style.destructiveIconTint
        default:
            return style.defaultIconTint
        }
    }
}
