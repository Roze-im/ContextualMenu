//
//  ContextMenuViewController.swift
//
//
//  Created by Thibaud David on 06/02/2023.
//

import UIKit

protocol ContextMenuViewControllerDelegate: AnyObject {
    func dismissContextMenuViewController(
        _ contextMenuViewController: ContextMenuViewController,
        interaction: ContextMenuInteractor.Interaction,
        uponTapping menuElement: MenuElement?
    )
}

class ContextMenuViewController: UIViewController {

    internal lazy var backgroundBlur: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: style.backgroundBlurStyle))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        v.alpha = 0

        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(onTouchUpInsideBackground)
        )
        v.addGestureRecognizer(gesture)
        return v
    }()

    /// A container for the preview, whose bounds matches transformed preview's bounds.
    /// It allows constraining menuView & accessoryView to final preview frame to facilitate
    /// animations.
    private lazy var previewTransformedBoundingView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let style: ContextMenuStyle

    /// The interaction reponsible of the ContextMenu
    let interaction: ContextMenuInteractor.Interaction

    /// An optional configuration for the ContextMenu.
    let menuConfiguration: ContextMenuConfiguration?

    /// Contains previewed subview parameters.
    var targetedPreview: UITargetedPreview?

    /// Snapshot of the view intended to be displayed as preview
    let previewRendering: UIView

    /// Original frame of the view to be previewed, expressed within screen's bounds
    let baseFrameInScreen: CGRect

    /// An optional accessory view to be displayed on top of the preview
    let accessoryView: UIView?

    /// An optional menuView, which gets built depending on `ContextMenuConfiguration`
    var menuView: MenuView?

    /// AccessoryView, casted as ContextMenuAnimatable.
    var animatableAccessoryView: ContextMenuAnimatable? { accessoryView as? ContextMenuAnimatable }

    weak var delegate: ContextMenuViewControllerDelegate?

    /// A list of constraints altering preview from its base position
    /// The take into account accessoryView, menu, and preview's transform
    /// to fit everything inside the view
    var constraintsAlteringPreviewPosition = [NSLayoutConstraint]()

    init(
        interaction: ContextMenuInteractor.Interaction,
        view: UIView,
        targetedPreview: UITargetedPreview,
        baseFrameInScreen: CGRect,
        delegate: ContextMenuViewControllerDelegate?
    ) {
        let configuration = interaction.menuConfigurationProvider(view)
        
        self.interaction = interaction
        self.menuConfiguration = configuration
        self.targetedPreview = targetedPreview
        self.style = interaction.style

        self.previewRendering = targetedPreview.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        self.previewRendering.layer.cornerRadius = style.menu.cornerRadius

        self.baseFrameInScreen = baseFrameInScreen
        self.accessoryView = configuration?.accessoryView
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
        self.overrideUserInterfaceStyle = style.overrideUserInterfaceStyle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = style.backgroundColor

        let alignmentToPreview = menuAndAccessoryViewAlignment()

        let backgroundConstraints = setupBackgroundBlur()
        // Preview must be kept above all in case it's too tall to fit in screen in which
        // case both accessoryView & menu will overlap
        let previewConstraints = setupPreview()
        let accessoryViewConstraints = setupAccessoryViewIfNeeded(alignment: alignmentToPreview)
        let menuConstraints = setupMenuViewIfNeeded(alignment: alignmentToPreview)

        // Immediately apply fixed constraints to setup initial state of view
        NSLayoutConstraint.activate(
            backgroundConstraints.fixed
            + accessoryViewConstraints.fixed
            + previewConstraints.fixed
            + menuConstraints.fixed
        )

        // Consolidate animatable constraints, for final position to be set
        // once enabled.
        constraintsAlteringPreviewPosition.append(contentsOf:
            backgroundConstraints.animatable
            + accessoryViewConstraints.animatable
            + previewConstraints.animatable
            + menuConstraints.animatable
        )

        view.layoutIfNeeded()
    }

    private func setupBackgroundBlur() -> FixedAndAnimatableConstraints {
        view.addSubview(backgroundBlur)
        return .init(
            fixed: [
                backgroundBlur.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ],
            animatable: []
        )
    }
    private func setupPreview() -> FixedAndAnimatableConstraints {
        /*
         Quick reminder:
         - targetedPreview: Native UITargetedPreview, aka parameters of view to parameters
         - targetedPreview.view: Original view
         - previewRendering: The view used as preview. It's a rendering (aka: a snapshot of original view)
         - previewTransformedBoundingView: A view used as container for `previewRendering`, whose frame
            matches the untransformed position of the rendering
         */
        previewRendering.translatesAutoresizingMaskIntoConstraints = false

        previewTransformedBoundingView.addSubview(previewRendering)
        view.addSubview(previewTransformedBoundingView)
        targetedPreview?.view.alpha = 0

        return FixedAndAnimatableConstraints(
            fixed: [
                previewRendering.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: baseFrameInScreen.minX
                ).priority(.defaultHigh),
                previewRendering.topAnchor.constraint(
                    equalTo: view.topAnchor,
                    constant: baseFrameInScreen.minY
                ).priority(.defaultHigh),
                previewRendering.widthAnchor.constraint(equalToConstant: baseFrameInScreen.width),
                previewRendering.heightAnchor.constraint(equalToConstant: baseFrameInScreen.height),
                previewTransformedBoundingView.widthAnchor.constraint(
                    equalToConstant: baseFrameInScreen.width * style.preview.transform.a
                ),
                previewTransformedBoundingView.heightAnchor.constraint(
                    equalToConstant: baseFrameInScreen.height * style.preview.transform.d
                ),
                previewTransformedBoundingView.centerXAnchor.constraint(equalTo: previewRendering.centerXAnchor),
                previewTransformedBoundingView.centerYAnchor.constraint(equalTo: previewRendering.centerYAnchor),
            ],
            animatable: [previewTransformedBoundingView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor)]
        )
    }
    private func setupAccessoryViewIfNeeded(
        alignment: Alignment
    ) -> FixedAndAnimatableConstraints {
        guard let accessoryView else { return .empty }

        view.addSubview(accessoryView)
        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        return FixedAndAnimatableConstraints(
            fixed: [
                accessoryView.bottomAnchor.constraint(
                    equalTo: previewTransformedBoundingView.topAnchor, constant: -style.preview.topMargin
                ).priority(.required - 1),
                alignment == .leading ?
                    accessoryView.leadingAnchor.constraint(equalTo: previewTransformedBoundingView.leadingAnchor).priority(.defaultHigh)
                    : accessoryView.trailingAnchor.constraint(equalTo: previewTransformedBoundingView.trailingAnchor).priority(.defaultHigh)
            ],
            animatable: NSLayoutConstraint.keeping(view: accessoryView, insideFrameOf: view)
        )
    }
    private func setupMenuViewIfNeeded(
        alignment: Alignment
    ) -> FixedAndAnimatableConstraints {
        guard let menuConfiguration, !menuConfiguration.menu.children.isEmpty else { return .empty }

        let menuView = MenuView(
            menu: menuConfiguration.menu,
            anchorPointAlignment: alignment,
            style: style.menu,
            delegate: self
        )
        self.menuView = menuView
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)

        return FixedAndAnimatableConstraints(
            fixed: [
                menuView.topAnchor.constraint(
                    equalTo: previewTransformedBoundingView.bottomAnchor, constant: style.preview.bottomMargin
                ),
                alignment == .leading ?
                    menuView.leadingAnchor.constraint(equalTo: previewTransformedBoundingView.leadingAnchor).priority(.defaultHigh)
                    : menuView.trailingAnchor.constraint(equalTo: previewTransformedBoundingView.trailingAnchor).priority(.defaultHigh)
            ],
            animatable: NSLayoutConstraint.keeping(view: menuView, insideFrameOf: view)
        )
    }
}

extension ContextMenuViewController {
    private struct FixedAndAnimatableConstraints {
        let fixed: [NSLayoutConstraint]
        let animatable: [NSLayoutConstraint]

        static let empty = FixedAndAnimatableConstraints(fixed: [], animatable: [])
    }
}

extension ContextMenuViewController {
    /// Returns alignment of menu & accessoryView relative to the preview.
    /// Items are aligned to leading if the preview is centered on the leading part of the screen, otherwise trailing
    private func menuAndAccessoryViewAlignment() -> Alignment {
        return baseFrameInScreen.midX > view.bounds.midX ? .trailing : .leading
    }
}

extension ContextMenuViewController {
    @objc private func onTouchUpInsideBackground(_ sender: Any?) {
        delegate?.dismissContextMenuViewController(self, interaction: self.interaction, uponTapping: nil)
    }
}

extension ContextMenuViewController: MenuViewDelegate {
    func dismissMenuView(menuView: MenuView, uponTapping menuElement: MenuElement) {
        delegate?.dismissContextMenuViewController(self, interaction: interaction, uponTapping: menuElement)
    }
}
