//
//  Block.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 10/16/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import SpriteKit

class Block: Node {
    var collisionComponents: [CollisionComponent] = []
    var updateComponents: [UpdateComponent] = []
    
    func spawn(at position: Point, in world: Node, size: Size) {
        world.addChild(self)
        self.position = position
        self.size = size
        geometry.node = self
        if geometry.vertices.isEmpty {
            genGeometry()
        }
    }
    
    func addComponent(_ component: CollisionComponent) {
        collisionComponents.append(component)
    }
    
    func addComponent(_ component: UpdateComponent) {
        updateComponents.append(component)
    }
    
    func onCollision(with player: Player) {
        for component in collisionComponents {
            let _ = component.onCollision(with: player)
        }
    }
    
    func genGeometry() {
        let rect = Rectangle(size: Size(width: size.width, height: size.height), color: self.geometry.color)
        geometry.vertices = rect.toVertices()
    }
    
    func onUpdate() {
        var removeComponents: [Int] = []
        for (index, component) in updateComponents.enumerated() {
            component.update()
            if component.oneTime {
                removeComponents.append(index)
            }
        }
        if !removeComponents.isEmpty {
            removeComponents.sort {$0 > $1}
            for index in removeComponents {
                updateComponents.remove(at: index)
            }
        }
    }
    
    func duplicate() -> Block {
        let copy = Block()
        copy.label = self.label
        copy.position = self.position
        copy.size = self.size
        copy.geometry.node = copy
        copy.geometry.vertices = self.geometry.vertices
        copy.geometry.color = self.geometry.color
        
        for component in collisionComponents {
            if let componentDuplicate = component.duplicate(forParent: copy) {
                copy.addComponent(componentDuplicate)
            }
        }
        
        for component in updateComponents {
            if let componentDuplicate = component.duplicate(forParent: copy) {
                copy.addComponent(componentDuplicate)
            }
        }
        
        return copy
    }
    
}
