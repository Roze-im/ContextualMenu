//
//  MenuView.swift
//  
//
//  Created by Thibaud David on 08/02/2023.
//

import Foundation
import UIKit

protocol MenuViewDelegate: AnyObject {
    func dismissMenuView(menuView: MenuView, uponTapping menuElement: MenuElement)
}

public final class MenuView: UIView {
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let menu: Menu
    let style: Style

    let anchorPointAlignment: Alignment

    weak var delegate: MenuViewDelegate?

    init(menu: Menu, anchorPointAlignment: Alignment, style: Style, delegate: MenuViewDelegate?) {
        self.menu = menu
        self.style = style
        self.anchorPointAlignment = anchorPointAlignment
        self.delegate = delegate

        super.init(frame: .zero)

        clipsToBounds = true
        layer.cornerRadius = style.cornerRadius
        backgroundColor = style.backgroundColor

        for (childIdx, child) in menu.children.enumerated() {
            let elementView = MenuElementView(element: child, style: style.element, delegate: self)
            stackView.addArrangedSubview(elementView)
            if childIdx < menu.children.count - 1 {
                stackView.addArrangedSubview(MenuView.buildSeparator(style: style))
            }
        }

        addSubview(stackView)

        let numberOfElements = CGFloat(menu.children.count)
        let numberOfSeparators = max(0, numberOfElements - 1)
        let totalElementsHeight = numberOfElements * style.element.height
        let totalSeparatorsHeight = numberOfSeparators * (1.0 / UIScreen.main.scale)
        let totalStackViewHeight = totalElementsHeight + totalSeparatorsHeight

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: style.width),
            stackView.heightAnchor.constraint(equalToConstant: totalStackViewHeight)
        ])
    }

    private static func buildSeparator(style: Style) -> UIView {
        let res = UIView()
        res.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
        res.backgroundColor = style.separatorColor
        return res
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuView: MenuElementViewDelegate {
    func menuElementViewTapped(menuElementView: MenuElementView) {
        delegate?.dismissMenuView(menuView: self, uponTapping: menuElementView.element)
    }
}
