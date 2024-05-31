//
//  MenuElement.swift
//  
//
//  Created by Thibaud David on 08/02/2023.
//

import Foundation
import UIKit

public struct MenuElement {
    let title: String
    let image: UIImage?
    let attributes: Attributes
    var handler: ((MenuElement) -> Void)?

    public init(
        title: String,
        image: UIImage? = nil,
        attributes: Attributes = .default,
        handler: ((MenuElement) -> Void)? = nil
    ) {
        self.title = title
        self.image = image
        self.attributes = attributes
        self.handler = handler
    }

    var uiAction: UIAction {
        return .init(
            title: title,
            image: image,
            attributes: attributes.uiAttributes,
            handler: { _ in
                handler?(self)
            }
        )
    }
}

extension MenuElement {
    public struct Attributes: OptionSet {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let `default` = Attributes(rawValue: 1 << 0)
        public static let destructive = Attributes(rawValue: 1 << 1)

        var uiAttributes: UIAction.Attributes {
            var attributes = UIAction.Attributes()
            if contains(.destructive) {
                attributes.insert(.destructive)
            }
            return attributes
        }
    }
}
