//
//  ViewController.swift
//  ContextMenuExample
//
//  Created by Thibaud David on 06/02/2023.
//

import UIKit
import ContextualMenu
import ElegantEmojiPicker

class ViewController: UIViewController {

    lazy var smallLabel: UILabel = {
        let l = UILabel()
        l.text = "Small Label"
        l.textColor = .blue
        l.sizeToFit()
        l.backgroundColor = .green
        return l
    }()
    
    lazy var reactionsLabel: UILabel = {
        let l = UILabel()
        l.text = "Reactions Label"
        l.textColor = .darkText
        l.backgroundColor = .secondarySystemBackground
        let y = UIScreen.main.bounds.height/3
        l.frame = CGRect(x: 0, y: y, width: 200, height: 100)
        l.sizeToFit()
        l.center.x = view.center.x
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

    lazy var collectionViewItems = ["a", "b", "c", "d"]
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let res = UICollectionView(frame: .zero, collectionViewLayout: layout)
        res.dataSource = self
        res.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        return res
    }()

    private func makeAccesorieView(for object: String, source: UIView?) -> UIView {
        let reactionView = ReactionsToolBar(currentSelected: "👍")
        
        reactionView.onSelectEmoji = { [weak self] emoji in
            if emoji == "+" {
                self?.showMoreReactions(source: source)
                return
            }
            reactionView.animateSelectedEmoji(to: emoji)
            UIView.dismissCurrentContextMenu()
        }
        reactionView.translatesAutoresizingMaskIntoConstraints = false
        reactionView.heightAnchor.constraint(equalToConstant: reactionView.frame.height).isActive = true
        reactionView.widthAnchor.constraint(equalToConstant: reactionView.frame.width).isActive = true
        
        return reactionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(reactionsLabel)
        
        reactionsLabel.addInteraction(targetedPreviewProvider: { view in
            return .init(view: self.reactionsLabel)
        }, menuConfigurationProvider: {  _ in
            return ContextMenuConfiguration(
                accessoryView: self.makeAccesorieView(for: "Spacial information", source: nil) ,
                menu: Menu(children: [
                    MenuElement(
                        title: "Calendar icon",
                        image: UIImage(systemName: "calendar"),
                        handler: { _ in print("Tapped") }
                    ),
                    MenuElement(title: "Calendar", handler: { _ in print("Tapped") })
                ])
            )
        }, style: ContextMenuStyle())
        

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
        view.addSubview(collectionView)

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

        collectionView.frame = CGRect(
            x: view.bounds.width - 100,
            y: view.bounds.height - 100,
            width: 100,
            height: 100
        )
    }

    @objc func onTouchUpInsideAccesoryView(_ sender: Any?) {
        print("onTouchUpInsideAccesoryView")
        UIView.dismissCurrentContextMenu()
    }
}

// MARK: - elegantEmoi
extension ViewController: ElegantEmojiPickerDelegate {
    func emojiPicker(_ picker: ElegantEmojiPicker,
                     didSelectEmoji emoji: Emoji?) {
        guard let emoji = emoji else { return }
        debugPrint("emojiPicker \(emoji)")
        UIView.dismissCurrentContextMenu()
    }
    
    private func showMoreReactions(source: UIView?) {
        let configuration  = ElegantConfiguration(showRandom: false,
                                                  showReset: false,
                                                  showClose: false)
        let picker = ElegantEmojiPicker(delegate: self,
                                        configuration: configuration,
                                        sourceView: source)
         UIView.present(picker, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        let text = "\(indexPath.item):\(collectionViewItems[indexPath.row])"
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = text
        } else {
            let label = UILabel(frame: .init(origin: .zero, size: .init(width: 25, height: 25)))
            label.text = text
            label.textAlignment = .center
            label.tag = 1
            cell.addSubview(label)
        }
        cell.backgroundColor = .gray
        cell.addInteraction(
            targetedPreviewProvider: { _ in
                return .init(view: cell)
            },
            menuConfigurationProvider: { [weak self] v in
                guard let self else { return .init(menu: .init(children: [])) }
                return ContextMenuConfiguration(
                    accessoryView: self.accessoryView,
                    menu: Menu(children: [
                        MenuElement(
                            title: "Cell tapped",
                            handler: { _ in print("Tapped") }
                        )
                    ])
                )
            }
        )
        return cell
    }
}
