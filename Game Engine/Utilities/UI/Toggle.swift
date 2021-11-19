//
//  Toggle.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/7/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

class Toggle: Node, Pressable {
    
    var onRelease: () -> () = {() -> () in }
    
    var toggled: UnsafeMutablePointer<Bool>
    var colors: (inactive: Color, active: Color)
    var indicator: Node
    
    init(of value: UnsafeMutablePointer<Bool>, sized size: Float, borderColor: Color, inactiveColor: Color, activeColor: Color) {
        self.colors = (inactiveColor, activeColor)
        self.toggled = value
        
        self.indicator = Node()
        
        super.init()
        self.size = Size(width: size, height: size)
        
        let borderShape = [
            " XXX ",
            "X   X",
            "X   X",
            "X   X",
            " XXX"
        ]
        let blockSize = size/Float(borderShape.count)
        let block = Block()
        block.geometry.color = borderColor
        block.size = Size(width: blockSize, height: blockSize)
        Rasterizer.rasterize(borderShape, repeating: block, sized: blockSize, in: self)
        
        let indicatorShape = [
            "XXX",
            "XXX",
            "XXX"
        ]
        block.geometry.color = toggled.pointee ? colors.active : colors.inactive
        indicator = Node()
        indicator.geometry.dynamic = true
        Rasterizer.rasterize(indicatorShape, repeating: block, sized: blockSize, in: indicator)
        self.addChild(indicator)
    }
    
    func toggle() {
        toggled.pointee = toggled.pointee ? false : true
        for node in indicator.children {
            node.geometry.color = toggled.pointee ? colors.active : colors.inactive
        }
        indicator.geometry.masterCompile()
    }
    
    func touched() {
        toggle()
        onRelease()
    }
    
}
