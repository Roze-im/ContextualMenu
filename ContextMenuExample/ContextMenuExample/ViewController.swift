//
//  ViewController.swift
//  ContextMenuExample
//
//  Created by Thibaud David on 06/02/2023.
//

import UIKit
import ContextualMenu

class ViewController: UIViewController {

    lazy var smallLabel: UILabel = {
        let l = UILabel()
        l.text = "Small Label"
        l.textColor = .blue
        l.sizeToFit()
        l.backgroundColor = .green
        return l
    }()

    lazy var bigLabelTopRight: UILabel = {
        let l = UILabel()
        l.text = "Top right\nMultiline\nBigLabel"
        l.textColor = .blue
        l.numberOfLines = 0
        l.sizeToFit()
        l.backgroundColor = .green
        return l
    }()
    lazy var bigLabelBottomLeft: UILabel = {
        let l = UILabel()
        l.text = "Bottom Left\nMultiline\nBigLabel"
        l.textColor = .blue
        l.numberOfLines = 0
        l.sizeToFit()
        l.backgroundColor = .green
        return l
    }()

    lazy var largeLabel: UILabel = {
        let l = UILabel()
        l.text = "CenteredLargeLabel"
        l.textColor = .blue
        l.numberOfLines = 0
        l.sizeToFit()
        l.backgroundColor = .red
        return l
    }()
    lazy var highLabel: UILabel = {
        let l = UILabel()
        l.text = "CenteredHighLabel"
        l.textColor = .blue
        l.numberOfLines = 0
        l.sizeToFit()
        l.backgroundColor = .purple
        return l
    }()

    lazy var accessoryView: UIView = {
        let b = UIButton()
        b.setTitle("Accessory button", for: .normal)
        b.sizeToFit()
        b.backgroundColor = .red
        b.addTarget(self, action: #selector(onTouchUpInsideAccesoryView(_:)), for: .touchUpInside)
        return b
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        [highLabel, largeLabel, smallLabel, bigLabelTopRight, bigLabelBottomLeft].forEach { subview in
            view.addSubview(subview)
            subview.addInteraction(
                targetedPreviewProvider: { _ in nil },
                menuConfigurationProvider: { [weak self] _ in
                    guard let self else { return nil }
                    return ContextMenuConfiguration(
                        accessoryView: self.accessoryView,
                        menu: Menu(children: [
                            MenuElement(
                                title: "Calendar icon",
                                image: UIImage(systemName: "calendar"),
                                handler: { _ in print("Tapped") }
                            ),
                            MenuElement(title: "Calendar", handler: { _ in print("Tapped") })
                        ])
                    )
                }
            )
        }

        view.addInteraction(
            targetedPreviewProvider: { [weak self] _ in
                guard let self else { return nil }
                return .init(view: self.smallLabel)
            },
            menuConfigurationProvider: { [weak self] v in
                guard let self else { return .init(menu: .init(children: [])) }
                return ContextMenuConfiguration(
                    accessoryView: self.accessoryView,
                    menu: Menu(children: [
                        MenuElement(
                            title: "View tapped, previewing a subview",
                            handler: { _ in print("Tapped") }
                        )
                    ])
                )
            }
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bigLabelTopRight.frame.origin = .init(x: view.bounds.width - bigLabelTopRight.bounds.width, y: view.safeAreaInsets.top)
        smallLabel.center = view.center
        bigLabelBottomLeft.frame.origin = .init(x: 0, y: view.bounds.height - view.safeAreaInsets.bottom - bigLabelTopRight.bounds.height)

        highLabel.frame = CGRect(
            x: 20, y: view.safeAreaInsets.top + 20, width: 100,
            height: view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 20 - bigLabelBottomLeft.bounds.height
        )
        largeLabel.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.bounds.width - 40, height: 20)
    }

    @objc func onTouchUpInsideAccesoryView(_ sender: Any?) {
        print("onTouchUpInsideAccesoryView")
        UIView.dismissCurrentContextMenu()
    }
}
