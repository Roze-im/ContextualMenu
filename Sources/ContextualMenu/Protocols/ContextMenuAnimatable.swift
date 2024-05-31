//
//  ContextMenuSubview.swift
//  
//
//  Created by Thibaud David on 16/02/2023.
//

import Foundation

public protocol ContextMenuAnimatable {
    func appearAnimation(completion: (() -> Void)?)
    func disappearAnimation(completion: (() -> Void)?)
}
public extension ContextMenuAnimatable {
    func appearAnimation() { appearAnimation(completion: nil) }
    func disappearAnimation() { disappearAnimation(completion: nil) }
}
