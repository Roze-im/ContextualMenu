# ContextualMenu

This package aims to replace native ContextMenu interaction as a nearly drop-in replacement.
It allows adding an accessoryView, as iMessage does using private APIs.

![screenshot](https://github.com/Roze-im/ContextualMenu/blob/main/ContextMenuExample/screenshot.jpeg) ![demo](https://github.com/Roze-im/ContextualMenu/blob/main/ContextMenuExample/demo.gif)

# Installation

## SPM
Add `https://github.com/Roze-im/ContextualMenu.git` to your dependencies 


# Usage

Add interaction on a view, using itself as preview
```swift
view.addInteraction(
    targetedPreviewProvider: { _ in nil },
    menuConfigurationProvider: { [weak self] v in
        guard let self else { return nil }
        return ContextMenuConfiguration(
            accessoryView: self.accessoryView,
            menu: Menu(children: [
                MenuElement(
                    title: "Title",
                    image: UIImage(named: "nice-icon"),
                    handler: { _ in }
                )
            ])
        )
    }
)
```

Add interaction on a view, using a subview as preview
```swift
view.addInteraction(
    targetedPreviewProvider: { [weak self] v in
        return .init(view: someSubview)
    },
    menuConfigurationProvider: { [weak self] v in
        guard let self else { return .init(menu: .init(children: [])) }
        return ContextMenuConfiguration(
            accessoryView: self.accessoryView,
            menu: Menu(children: [
                MenuElement(
                    title: "View tapped, previewing a subview",
                    handler: { _ in }
                )
            ])
        )
    }
)
```

# Custom accessory view animation

To get a custom animation to show/hide your accessoryView, it can simply implement `ContextMenuAnimatable`.

```swift
public protocol ContextMenuAnimatable {
    func appearAnimation(completion: (() -> Void)?)
    func disappearAnimation(completion: (() -> Void)?)
}
```

