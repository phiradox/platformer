//
//  RenderComponent.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/11/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import Foundation

protocol UpdateComponent {
    var oneTime: Bool { get }
    weak var parent: Block! { get }
    func duplicate(forParent parent: Block) -> UpdateComponent?
    func update() -> Void
}

class Moving: UpdateComponent {
    weak internal var parent: Block!
    internal var oneTime: Bool
    var movement: Vector2
    weak var scene: Scene!
    
    init(by movement: Vector2, for block: Block, in scene: Scene) {
        self.parent = block
        self.movement = movement
        oneTime = true
        self.scene = scene
        self.parent.geometry.dynamic = true
    }
    
    func update() {
        scene.updateLoops.append({() -> (Bool) in
            if let _ = self.parent {
                // getting a hold of the blocks
                let blocks = (self.scene as! GameScene).levelManager.blocks
                
                // Rasterizing the block's grid position for collision detecting
                let rasterizedX = Int(self.parent.position.x/GlobalVars.tileSize)
                let rasterizedY = Int(self.parent.position.y/GlobalVars.tileSize)
                
                // Testing for conflicts with future locations
                var potentialBlockX = rasterizedX
                var potentialBlockY = rasterizedY
                potentialBlockX += self.movement.x > 0 ? 1 : (self.movement.x < 0 ? -1 : 0)
                potentialBlockY += self.movement.y > 0 ? 1 : (self.movement.y < 0 ? -1 : 0)
                
                // x movement
                if let block = blocks.staticBlocks[potentialBlockX][rasterizedY] {
                    let dummy = Block()
                    dummy.position = self.parent.position
                    dummy.position.x += self.movement.x
                    dummy.size = self.parent.size
                    if block.intersects(dummy) {
                        self.movement.x = -self.movement.x
                    }
                }
                
                // y movement
                if let block = blocks.staticBlocks[rasterizedX][potentialBlockY] {
                    let dummy = Block()
                    dummy.position = self.parent.position
                    dummy.position.y += self.movement.y
                    dummy.size = self.parent.size
                    if block.intersects(dummy) {
                        self.movement.y = -self.movement.y
                    }
                }
                
                self.parent.position.x += self.movement.x
                self.parent.position.y += self.movement.y
                
                return false
            } else {
                return true
            }
        })
    }
    
    internal func duplicate(forParent parent: Block) -> UpdateComponent? {
        let component = Moving(by: movement, for: parent, in: self.scene)
        print("Moving component duplicated")
        return component
    }
}
