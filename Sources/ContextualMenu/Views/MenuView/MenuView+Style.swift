//
//  MenuView+Style.swift
//  
//
//  Created by Thibaud David on 17/02/2023.
//

import Foundation
import UIKit

extension MenuView {
    public struct Style {
        let backgroundColor: UIColor
        let separatorColor: UIColor
        let cornerRadius: CGFloat
        let element: MenuElementView.Style
        let width: CGFloat

        let disappearedScalingValue: CGFloat

        let apparition: AnimationParameters
        let disapparition: AnimationParameters

        public init(
            backgroundColor: UIColor = .white.withAlphaComponent(0.39),
            separatorColor: UIColor = .darkGray,
            cornerRadius: CGFloat = 12,
            element: MenuElementView.Style = MenuElementView.Style(),
            width: CGFloat = 250,
            disappearedScalingValue: CGFloat = 0.0001,
            apparition: AnimationParameters = AnimationParameters(),
            disapparition: AnimationParameters = AnimationParameters()
        ) {
            self.backgroundColor = backgroundColor
            self.separatorColor = separatorColor
            self.cornerRadius = cornerRadius
            self.element = element
            self.width = width
            self.disappearedScalingValue = disappearedScalingValue
            self.apparition = apparition
            self.disapparition = disapparition
        }
    }
}
