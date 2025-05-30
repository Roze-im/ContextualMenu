//
//  MenuElementView.swift
//  
//
//  Created by Thibaud David on 08/02/2023.
//

import Foundation
import UIKit

protocol MenuElementViewDelegate: AnyObject {
    func menuElementViewTapped(menuElementView: MenuElementView)
}

public final class MenuElementView: UIView {

    lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.attributedText = .init(
            string: element.title,
            attributes: MenuElementView.titleAttributes(
                attributes: element.attributes,
                style: style
            )
        )
        return l
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = element.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = MenuElementView.iconTint(attributes: element.attributes, style: style)
        return iv
    }()
    lazy var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(onButtonTouchedUpInside), for: .touchUpInside)
        return b
    }()

    let element: MenuElement

    let style: Style

    weak var delegate: MenuElementViewDelegate?

    init(element: MenuElement, style: Style, delegate: MenuElementViewDelegate?) {

        self.element = element
        self.style = style
        self.delegate = delegate

        super.init(frame: .zero)

        addSubview(button)
        addSubview(label)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 2),
            imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 2),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: element.image == nil ? 0 : style.iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: style.iconSize.height)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onButtonTouchedUpInside(_ sender: Any?) {
        delegate?.menuElementViewTapped(menuElementView: self)
    }
}
