//
//  ContextMenuInteractor.swift
//  
//
//  Created by Thibaud David on 06/02/2023.
//

import Foundation
import UIKit

class ContextMenuInteractor {

    static let shared = ContextMenuInteractor()
    static let kGesturePressDuration = TimeInterval(0.22)

    let window: UIWindow = {
        let w = UIWindow()
        w.backgroundColor = .clear
        return w
    }()
    weak var viewOriginalWindow: UIWindow?
    var contextMenuViewController: ContextMenuViewController?

    /// Using an NSMapTable instead of a Dictionary, as NSMapTable allows referencing weakly keys.
    let interactions = NSMapTable<UIView, Interaction>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    func addInteraction(
        on view: UIView,
        targetedPreviewProvider: @escaping TargetedPreviewProvider,
        menuConfigurationProvider: @escaping MenuConfigurationProvider,
        style: ContextMenuStyle
    ) {
        removeInteraction(from: view)

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(beginInteraction(_:)))
        gesture.minimumPressDuration = ContextMenuInteractor.kGesturePressDuration

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)

        interactions.setObject(.init(
            gesture: gesture,
            targetedPreviewProvider: targetedPreviewProvider,
            menuConfigurationProvider: menuConfigurationProvider,
            style: style
        ), forKey: view)
    }

    func removeInteraction(from view: UIView) {
        guard let interaction = interactions.object(forKey: view) else { return }
        view.removeGestureRecognizer(interaction.gesture)
        interactions.removeObject(forKey: view)
    }

    @objc func beginInteraction(_ sender: UIGestureRecognizer) {
        guard sender.state == .began,
              let view = sender.view,
              let interaction = interactions.object(forKey: view) else {
            return
        }

        interaction.gesture.isEnabled = false

        viewOriginalWindow = view.window

        let targetedPreview = interaction.targetedPreviewProvider(view) ?? .init(view: view)
        let contextMenuController = ContextMenuViewController(
            interaction: interaction,
            view: view,
            targetedPreview: targetedPreview,
            baseFrameInScreen: targetedPreview.view.convert(targetedPreview.view.bounds, to: nil),
            delegate: self
        )
        self.contextMenuViewController = contextMenuController
        contextMenuController.view.frame = window.bounds
        window.windowLevel = interaction.style.windowLevel
        window.windowScene = viewOriginalWindow?.windowScene
        window.rootViewController = contextMenuController

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        window.makeKeyAndVisible()

        contextMenuController.appearAnimation()
    }

    public func dismissContextMenu(view: UIView, completion: (() -> Void)?) {
        dismissContextMenu(
            interaction: interactions.object(forKey: view),
            completion: completion
        )
    }
    func dismissCurrentContextMenu(completion: (() -> Void)? = nil) {
        guard let contextMenuViewController else {
            completion?()
            return
        }
        dismissContextMenu(interaction: contextMenuViewController.interaction, completion: completion)
    }
    func dismissContextMenu(interaction: Interaction?, completion: (() -> Void)?) {
        contextMenuViewController?.disappearAnimation { [weak self] in
            interaction?.gesture.isEnabled = true
            self?.restoreWindow()
            completion?()
        }
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if contextMenuViewController == window.rootViewController {
            contextMenuViewController?.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }


    private func restoreWindow() {
        window.rootViewController = nil
        window.isHidden = true
        window.windowScene = nil
    }
}

extension ContextMenuInteractor: ContextMenuViewControllerDelegate {
    func dismissContextMenuViewController(
        _ contextMenuViewController: ContextMenuViewController,
        interaction: ContextMenuInteractor.Interaction,
        uponTapping menuElement: MenuElement?
    ) {
        dismissContextMenu(interaction: interaction) {
            if let menuElement {
                menuElement.handler?(menuElement)
            }
        }
    }
}

extension ContextMenuInteractor {
    class Interaction {
        let gesture: UIGestureRecognizer
        let targetedPreviewProvider: TargetedPreviewProvider
        let menuConfigurationProvider: MenuConfigurationProvider
        let style: ContextMenuStyle

        init(
            gesture: UIGestureRecognizer,
            targetedPreviewProvider: @escaping TargetedPreviewProvider,
            menuConfigurationProvider: @escaping MenuConfigurationProvider,
            style: ContextMenuStyle
        ) {
            self.gesture = gesture
            self.targetedPreviewProvider = targetedPreviewProvider
            self.menuConfigurationProvider = menuConfigurationProvider
            self.style = style
        }
    }
}
