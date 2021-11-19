//
//  TextInputNode.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/2/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

class TextInput {
    
    static var inputView: UIView? = nil
    static var attachedNode: TextInputNode? = nil
    static var active: Bool = false
    
    static func enableKeyboard() {
        inputView?.becomeFirstResponder()
        active = true
    }
    
    static func disableKeyboard() {
        inputView?.resignFirstResponder()
        active = false
    }
    
    static func initializeInView(_ view: UIView) {
        if let inputView = self.inputView {
            inputView.removeFromSuperview()
            self.inputView = nil
        }
        inputView = TextInputView()
        view.addSubview(inputView!)
    }
    
    static func destroyInput() {
        inputView?.removeFromSuperview()
    }
    
}

class TextInputNode: TextNode, Pressable {
    var onRelease: () -> () = {() -> () in }

    var action: () -> () = {
        if TextInput.active {
            TextInput.disableKeyboard()
        } else {
            TextInput.enableKeyboard()
        }
    }
    
    var compiledChars: [Character:Node] = [:]
    
    override init(of string: String, madeOf block: Block, sized size: Float, at position: Point) {
        super.init(of: string, madeOf: block, sized: size, at: position)
        text = string
        for char in TextNode.characters.keys {
            let shape = TextNode.characters[char]!
            let node = Node()
            node.geometry.dynamic = true
            let offset = Point(x: Float(shape[0].count)*tileSize/2, y: Float(shape.count)*tileSize/2)
            Rasterizer.rasterize(shape, repeating: block, sized: tileSize, in: node, offset: offset)
            compiledChars[char] = node
        }
        prepare()
    }
    
    
    func addChar(_ char: Character) {
        if let nodeToAdd = compiledChars[char] {
            let copyNode = Node()
            copyNode.geometry.dynamic = true
            copyNode.size = nodeToAdd.size
            copyNode.children = nodeToAdd.children
            copyNode.position.x = self.size.width + tileSize
            self.size.width += tileSize + copyNode.size.width
            text.append(char)
            self.addChild(copyNode)
        }
    }
    
    override func compile() {
        
    }
    
    func prepare() {
        let stringToCompile = text
        text = ""
        for char in stringToCompile {
            addChar(char)
        }
    }
    
    func removeLast() {
        if let lastChild = children.last {
            self.size.width -= lastChild.size.width + tileSize
            lastChild.removeFromParent()
            text = String(text.dropLast())
        }
        
    }
    
    func touched() {
        action()
    }
}

class TextInputView: UIView, UIKeyInput {
    var hasText: Bool {
        get {
            return true
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func insertText(_ text: String) {
        if let textNode = TextInput.attachedNode {
            for char in text {
                textNode.addChar(char)
            }
        }
    }
    
    func deleteBackward() {
        if let textNode = TextInput.attachedNode {
            textNode.removeLast()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GlobalVars.currentScene.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        GlobalVars.currentScene.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        GlobalVars.currentScene.touchesEnded(touches, with: event)
    }
    
}
