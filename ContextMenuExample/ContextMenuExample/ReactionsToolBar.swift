//
//  ReactionsToolBar.swift
//  ContextMenuExample
//
//  Created by MLabs on 03/06/2025.
//


import UIKit

final class ReactionsToolBar: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var onSelectEmoji: ((String) -> Void)?
    
    let padding = 4.0
    static let height: CGFloat = 58
    
    let selectedEfectView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.2)
        return view
    }()
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private var buttons: [SectionButton] = []
    
    init(currentSelected: String?) {
        let emojis = ["👍", "❤️", "😂", "😮", "😢", "🙏", "+"]
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: ReactionsToolBar.height))
        
        blur.clipsToBounds = true
        addSubview(blur)
        blur.frame = bounds
        
        selectedEfectView.clipsToBounds = true
        addSubview(selectedEfectView)
        
        for (index, emoji) in emojis.enumerated() {
            let button: SectionButton

            if index == emojis.count - 1 {
                button = SectionButton(emoji, isSelected: false, isPlus: true) { [weak self] selected in
                    self?.onSelectEmoji?(selected)
                }
            } else {
                button = SectionButton(emoji, isSelected: currentSelected == emoji) { [weak self] selected in
                    self?.onSelectEmoji?(selected)
                }
            }
            
            buttons.append(button)
            addSubview(button)
        }

        layoutButtons()
    }
    
    public func animateSelectedEmoji(to emoji: String) {
        guard let index = buttons.firstIndex(of: buttons.first(where: { $0.emoji == emoji })!) else { return }
        let button = buttons[index]
        
        UIView.animate(withDuration: 0.2) {
            self.selectedEfectView.center = button.center
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
        blur.layer.cornerRadius = blur.frame.height * 0.5
        layoutButtons()
    }
    
    private func layoutButtons() {
        let buttonCount = CGFloat(buttons.count)
        let buttonSpacing: CGFloat = 2
        let availableWidth = bounds.width - 2 * padding
        let buttonWidth = (availableWidth - buttonSpacing * (buttonCount - 1)) / buttonCount
        
        var selectedCenterPoint: CGPoint?
        for (index, button) in buttons.enumerated() {
            let x = padding + CGFloat(index) * (buttonWidth + buttonSpacing)
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: bounds.height)
            if button.isSelected {
                selectedCenterPoint =  button.center
                selectedEfectView.frame = CGRect(x: 0, y: 0,
                                                 width: buttonWidth + 4,
                                                 height: buttonWidth + 4)
            }
        }
        
        if let selectedCenterPoint {
            selectedEfectView.center = selectedCenterPoint
            selectedEfectView.layer.cornerRadius = selectedEfectView.bounds.height * 0.5
            selectedEfectView.isHidden = false
        } else {
            selectedEfectView.isHidden = true
        }
    }
    
    class SectionButton: UIView {
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        let label = UILabel()
        let backSelectView = UIView()
        var onSelectEmoji: ((String) -> Void)
        let emoji: String
        let spacing: CGFloat = 0
        let isPlus: Bool
        let isSelected: Bool
        
        init(_ emoji: String,
             isSelected: Bool,
             isPlus: Bool = false,
             onSelect: @escaping ((String) -> Void))
        {
            self.emoji = emoji
            self.onSelectEmoji = onSelect
            self.isPlus = isPlus
            self.isSelected = isSelected
            super.init(frame: CGRect(x: 0, y: 0,
                                     width: ReactionsToolBar.height,
                                     height: ReactionsToolBar.height))
            
            if isPlus {
                let plusImage = UIImage(systemName: "plus")
                let imageView = UIImageView(image: plusImage)
                imageView.tintColor = .gray
                imageView.contentMode = .scaleAspectFit
                
                configureBackSelectView(of: imageView, inset: 4, spacing: 4)
                
            } else {
                label.font = .systemFont(ofSize: 30, weight: .medium)
                
                label.text = emoji
                label.textAlignment = .center
                label.contentMode = .scaleAspectFit
                label.tintColor = .systemGray
                
                configureBackSelectView(of: label, inset: 0, spacing: 0)
            }
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Tap)))
        }
        
        private func configureBackSelectView(of view: UIView, inset: CGFloat, spacing: CGFloat) {
            addSubview(backSelectView)
            backSelectView.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: backSelectView.topAnchor,
                                           constant: inset).isActive = true
            view.leftAnchor.constraint(equalTo: backSelectView.leftAnchor,
                                           constant: inset).isActive = true
            view.rightAnchor.constraint(equalTo: backSelectView.rightAnchor,
                                           constant: -inset).isActive = true
            view.bottomAnchor.constraint(equalTo: backSelectView.bottomAnchor,
                                           constant: -inset).isActive = true
            
            
            backSelectView.frame = CGRect(x: spacing, y: spacing,
                                     width: bounds.width - 2 * spacing,
                                     height: bounds.height - 2 * spacing)
            backSelectView.layer.cornerRadius = backSelectView.frame.width / 2
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let height = (bounds.width - 2 * spacing)
            let width = height
            let y = (bounds.height - height) / 2
            let x = (bounds.width - width) / 2
            backSelectView.frame = CGRect(x: x, y: y,
                                     width: height,
                                     height: height)
            backSelectView.layer.cornerRadius = backSelectView.frame.width / 2
            
            if isPlus {
                backSelectView.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.2)
            } else {
                backSelectView.backgroundColor = .clear
            }
        }
        
        @objc func Tap() {
            onSelectEmoji(emoji)
        }
    }
}
