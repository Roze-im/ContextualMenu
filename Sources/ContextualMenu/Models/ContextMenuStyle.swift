//
//  ContextMenuStyle.swift
//  
//
//  Created by Thibaud David on 17/02/2023.
//

import Foundation
import UIKit

public struct ContextMenuStyle {
    public let windowLevel: UIWindow.Level
    public let backgroundColor: UIColor
    public let backgroundBlurStyle: UIBlurEffect.Style
    public let blurAlpha: CGFloat
    public let overrideUserInterfaceStyle: UIUserInterfaceStyle

    public let apparition: AnimationParameters
    public let disapparition: AnimationParameters

    public let preview: Preview
    public let menu: MenuView.Style

    public static let `default` = ContextMenuStyle()

    public init(
        windowLevel: UIWindow.Level = .statusBar - 1,
        backgroundColor: UIColor = .clear,
        backgroundBlurStyle: UIBlurEffect.Style = .systemUltraThinMaterial,
        blurAlpha: CGFloat = 1,
        overrideUserInterfaceStyle: UIUserInterfaceStyle = .unspecified,
        apparition: AnimationParameters = AnimationParameters(),
        disapparition: AnimationParameters = AnimationParameters(),
        preview: Preview = Preview(),
        menu: MenuView.Style = MenuView.Style()
    ) {
        self.windowLevel = windowLevel
        self.backgroundColor = backgroundColor
        self.backgroundBlurStyle = backgroundBlurStyle
        self.blurAlpha = blurAlpha
        self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        self.apparition = apparition
        self.disapparition = disapparition
        self.preview = preview
        self.menu = menu
    }
}

extension ContextMenuStyle {
    public struct Preview {
        public var transform: CGAffineTransform
        public var topMargin: CGFloat
        public var bottomMargin: CGFloat

        public var shadow: ShadowParameters

        public init(
            transform: CGAffineTransform = .identity,
            topMargin: CGFloat = 8,
            bottomMargin: CGFloat = 8,
            shadow: ShadowParameters = .init()
        ) {
            self.transform = transform
            self.topMargin = topMargin
            self.bottomMargin = bottomMargin
            self.shadow = shadow
        }
    }
}
