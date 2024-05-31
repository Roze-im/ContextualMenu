//
//  ShadowParameters.swift
//  
//
//  Created by Thibaud David on 16/02/2023.
//

import CoreGraphics

public struct ShadowParameters {
    public var color: CGColor
    public var offset: CGSize
    public var radius: CGFloat
    public var opacity: Float

    public static let none = ShadowParameters(opacity: 0)

    public init(
        color: CGColor = .init(red: 0, green: 0, blue: 0, alpha: 0),
        offset: CGSize = .init(width: 0, height: 1),
        radius: CGFloat = 5,
        opacity: Float = 0
    ) {
        self.color = color
        self.offset = offset
        self.radius = radius
        self.opacity = opacity
    }
}
