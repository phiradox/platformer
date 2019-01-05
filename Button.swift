//
//  Button.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 1/29/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import SpriteKit

class Button: Node, Pressable {
    
    var onRelease: () -> () = {}
    
    func spawn(in parent: Node, at position: Point, withSize size: Size, onTouch action: @escaping () -> ()) {
        parent.addChild(self)
        self.position = position
        self.size = size
        self.onRelease = action
        geometry.node = self
        geometry.vertices = Rectangle(size: size, color: Color.init(r: 1, g: 1, b: 1, a: 1)).toVertices()
    }
    
    func touched() {
        onRelease()
    }
    
}

