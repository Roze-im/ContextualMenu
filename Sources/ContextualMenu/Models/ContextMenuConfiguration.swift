//
//  ContextMenuConfiguration.swift
//  
//
//  Created by Thibaud David on 06/02/2023.
//

import Foundation
import UIKit

public struct ContextMenuConfiguration {
    /// AccessoryView to display on top of preview.
    /// If your view conforms to `ContextMenuAnimatable`, then
    /// provided animations will be used to show/hide view
    weak var accessoryView: UIView?
    let menu: Menu

    public init(accessoryView: UIView? = nil, menu: Menu) {
        self.accessoryView = accessoryView
        self.menu = menu
    }

    // Builds a native UIContextMenuConfiguration, from a custom one.
    // We use this logic instead of the reversed one (building a custom-one from a native)
    // as UIAction (menu.children) don't expose `handler` field, preventing us from building
    // a custom object.
    public var uiContextMenuConfiguration: UIContextMenuConfiguration {
        return .init(
            actionProvider: { _ -> UIMenu? in
                return menu.uiMenu
            }
        )
    }
}
