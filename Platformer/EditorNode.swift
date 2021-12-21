//
//  EditorNode.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/17/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.

import Foundation
import SpriteKit

class EditorNode: Button {
    
    var block: Block? = nil
    var empty: Bool = true
    
    override func spawn(in parent: Node, at position: Point, withSize size: Size, onTouch action: @escaping () -> ()) {
        super.spawn(in: parent, at: position, withSize: size, onTouch: action)
        let block = Block()
        block.spawn(at: Point(x: 0, y: 0), in: self, size: self.size)
        block.geometry.vertices = Rectangle(size: Size(width: self.size.width/2, height: self.size.height/2), color: Color(r: 1, g: 1, b: 1, a: 1)).toVertices()
        self.block = block
        self.geometry.vertices = []
        
        // check if we should expand the leveleditor view. we want a frame equal to the screen size all around the level at all times.
        let levelEditorScene = parent.parent as! LevelEditorScene
        
        let leftmostLevel = levelEditorScene.bounds.left + levelEditorScene.size.width
        let rightmostLevel = levelEditorScene.bounds.right - levelEditorScene.size.width
        let topmostLevel = levelEditorScene.bounds.top - levelEditorScene.size.height
        let bottommostLevel = levelEditorScene.bounds.bottom + levelEditorScene.size.height
                
        if (position.x < leftmostLevel) {
            levelEditorScene.bounds.left = position.x - levelEditorScene.size.width

            levelEditorScene.levelScrollView.contentSize = CGSize(width: CGFloat(levelEditorScene.bounds.right - levelEditorScene.bounds.left), height: CGFloat(levelEditorScene.bounds.top - levelEditorScene.bounds.bottom))
            
            levelEditorScene.levelScrollView.contentOffset.x += CGFloat(leftmostLevel-position.x)
            
            levelEditorScene.levelScrollView.nodeOffset.x = -position.x+levelEditorScene.size.width/2
            levelEditorScene.levelScrollView.scrollViewDidScroll(levelEditorScene.levelScrollView)
        }
        if (position.y > topmostLevel) {
            levelEditorScene.bounds.top = position.y + levelEditorScene.size.height

            levelEditorScene.levelScrollView.contentSize = CGSize(width: CGFloat(levelEditorScene.bounds.right-levelEditorScene.bounds.left), height: CGFloat(levelEditorScene.bounds.top - levelEditorScene.bounds.bottom))
            
            // increments positively since position.y > topmostLevel
            levelEditorScene.levelScrollView.contentOffset.y -= CGFloat(topmostLevel-position.y)
            
            levelEditorScene.levelScrollView.nodeOffset.y = -position.y-levelEditorScene.size.height/2
            levelEditorScene.levelScrollView.scrollViewDidScroll(levelEditorScene.levelScrollView)
        }
        if (position.y < bottommostLevel) {
            levelEditorScene.bounds.bottom = position.y - levelEditorScene.size.height

            levelEditorScene.levelScrollView.contentSize = CGSize(width: CGFloat(levelEditorScene.bounds.right-levelEditorScene.bounds.left), height: CGFloat(levelEditorScene.bounds.top - levelEditorScene.bounds.bottom))
        }
        if (position.x > rightmostLevel) {
            levelEditorScene.bounds.right = position.x + levelEditorScene.size.width

            levelEditorScene.levelScrollView.contentSize = CGSize(width: CGFloat(levelEditorScene.bounds.right-levelEditorScene.bounds.left), height: CGFloat(levelEditorScene.bounds.top - levelEditorScene.bounds.bottom))
            
        }
    }
    
    func setBlock(to char: Character) {
        if let newBlock = GlobalVars.blockTypes.editorBlocks[char]?.block {
            empty = false
            self.block?.removeFromParent()
            self.block = newBlock.duplicate()
            self.block!.spawn(at: Point(x: 0, y: 0), in: self, size: self.size)
            self.block!.onUpdate()
        } else if char == "@" {
            empty = false
            self.block?.removeFromParent()
            let newBlock = Block()
            newBlock.geometry.vertices = Rectangle(size: Size(width: GlobalVars.tileSize/2, height: GlobalVars.tileSize), color: Color(r: 1, g: 1, b: 1, a: 1)).toVertices()
            newBlock.label = "@"
            self.addChild(newBlock)
            self.block = newBlock
        }
    }
    
    override func touched() {
        // switch block
        let levelEditorScene = GlobalVars.currentScene as! LevelEditorScene
        if !empty {
            self.block?.removeFromParent()
            let block = Block()
            block.spawn(at: Point(x: 0, y: 0), in: self, size: self.size)
            block.geometry.vertices = Rectangle(size: Size(width: self.size.width/2, height: self.size.height/2), color: Color(r: 1, g: 1, b: 1, a: 1)).toVertices()
            self.block = block
            empty = true
        } else {
            self.block?.removeFromParent()
            let block = levelEditorScene.selectedBlock.duplicate()
            block.spawn(at: Point(x: 0, y: 0), in: self, size: self.size)
            self.block = block
            empty = false
        }
        
        // create surrounding nodes to 'expand' the level in a 9x9 vicinity
        // check a 3 by 3 area
        for x in -1...1 {
            for y in -1...1 {
                let screenPosition = self.screenPosition
                let nodeCoords = Point(x: screenPosition.x + Float(x) * self.size.width, y: screenPosition.y + Float(y) * self.size.height)
                var spawn = true
                for node in levelEditorScene.nodes(at: nodeCoords, relativeTo: .screen) {
                    if let _ = node as? EditorNode {
                        spawn = false
                    }
                }
                if spawn {
                    let editorNode = EditorNode()
                    editorNode.spawn(in: levelEditorScene.levelNode, at: Point(x: self.position.x + Float(x) * self.size.width, y: self.position.y + Float(y) * self.size.height), withSize: Size(width: self.size.width, height: self.size.height), onTouch: {() -> () in })
                    //levelEditorScene.editorNodes.append(editorNode)
                }
            }
        }
        parent?.geometry.masterCompile()
    }
    
}

