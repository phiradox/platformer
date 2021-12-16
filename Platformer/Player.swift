//
//  Player.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 10/29/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import SpriteKit

class Player: Node {
    
    weak var gameScene: GameScene! = nil
    var velocity: Vector2 = Vector2(x: 0, y: 0)
    var friction: Vector2 = Vector2(x: 1, y: 1)
    var ground: Bool = false
    
    var water: Bool = false
    var waterBlock: Block? = nil
    
    let dummy = Node()
    var dead = false
    
    var startPosition: Point! = nil
    
    var input: (left: Bool, right: Bool, jump: Bool) = (false, false, false)
    
    // TODO: make this far easier, maybe make an enum for the array indices
    var velocityConstants: [Float] = []
    
    var coins: Int = 0
    
    var collision: (horizontal: Bool, vertical: Bool) = (false, false)
    var bounced: (horizontal: Bool, vertical: Bool) = (false, false)
    
    func spawn(in gameScene: GameScene, and parent: Node, at position: Point, with size: Size) {
        
        self.gameScene = gameScene
        parent.addChild(self)
        self.position = position
        self.startPosition = position
        self.size = size
        self.velocity = Vector2(x: 0, y: 0)
        
        geometry = Geometry(of: self)
        self.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
        let rect = Rectangle(size: size, color: self.geometry.color)
        self.geometry.vertices = rect.toVertices()
        geometry.dynamic = true
        
        dummy.size = self.size
        
        // init dampener velocities proportional to tileSize
        // TODO: enum for indices, see above at variable declaration
        velocityConstants.append(contentsOf: [gameScene.tileSize/100, gameScene.tileSize/200*3, gameScene.tileSize/20*3, gameScene.tileSize/40, gameScene.tileSize/20*6.83125])
    }
    
    func update(with blocks: Blocks, and input: (left: Bool, right: Bool, jump: Bool)) {
        self.input(input: input)
        self.input = input
        
        let oldFriction = friction
        // will be modified if on collision with a block with a friction component
        // CHECK: the lower valued friction is preferred when cycling through blocks/friction components
        friction.x = 1
        friction.y = 1
        
        let conflictions = collidedBlocks(blocks: blocks)
        bounced = (false, false)
        self.water = false
        for tuple in conflictions {
            collision = tuple.collision
            tuple.block.onCollision(with: self)
        }
        
        if oldFriction.x < friction.x {
            velocity.x = velocity.x / friction.x
        }
        
        if oldFriction.y < friction.y {
            velocity.y = velocity.y / friction.y
        }
        
        position.x += velocity.x
        position.y += velocity.y
        
        velocity.y -= velocityConstants[0] / friction.y
        
        if velocity.x <= velocityConstants[0] / friction.x && velocity.x >= -velocityConstants[0] / friction.x {
            velocity.x = 0
        }
        if velocity.x > velocityConstants[0] / friction.x {
            let oldValue = velocity.x
            velocity.x -= velocityConstants[0] * friction.x
            // if the value of the velocity changed signs make it equal to 0. (subtracted too much)
            if oldValue * velocity.x < 0 {
                velocity.x = 0
            }
        }
        if velocity.x < -velocityConstants[0] / friction.x {
            let oldValue = velocity.x
            velocity.x += velocityConstants[0] * friction.x
            // if the value of the velocity changed signs make it equal to 0. (added too much)
            if oldValue * velocity.x < 0 {
                velocity.x = 0
            }
        }
        if velocity.x > velocityConstants[2] / friction.x {
            velocity.x -= velocityConstants[1] * friction.x
        }
        if velocity.x < -velocityConstants[2] / friction.x {
            velocity.x += velocityConstants[1] * friction.x
        }
        
        if position.y < gameScene.levelManager.world.position.y - gameScene.size.height {
            dead = true
        }
    }
    
    func input(input: (left: Bool, right: Bool, jump: Bool)) {
        if input.left {
            velocity.x -= velocityConstants[3] / friction.x
        }
        if input.right {
            velocity.x += velocityConstants[3] / friction.x
        }
        
        if input.jump && ground {
            ground = false
            velocity.y = velocityConstants[4] / friction.y
            
        } else if input.jump && water {
            if velocity.y < GlobalVars.tileSize/20 * 2 {
                velocity.y += velocityConstants[3]
            }
        } else if input.jump {
            if let block = waterBlock {
                if block.position.y + block.size.height/2 <= self.position.y - self.size.height/2 {
                    velocity.y += 3
                }
            }
        }
        if !water {
            waterBlock = nil
        }
    }
    
    // MARK: Collision detection
    
    func collidedBlocks(blocks: Blocks) -> [(block: Block, collision: (Bool, Bool))] {
        var collidable: [Block] = []
        // rasterize the player's position and make a 5 by 5 rectangle around it of blocks
        // optimizes to test only 25 *static* blocks max
        let rasterizedX = Int(self.position.x/gameScene.tileSize)
        let rasterizedY = Int(self.position.y/gameScene.tileSize)
        
        // append all dynamic blocks
        collidable.append(contentsOf: blocks.responsiveBlocks)
        collidable.append(contentsOf: blocks.animateBlocks)
        
        // append only blocks in a small area to reduce cpu load
        let boundShiftX = Int(velocity.x / GlobalVars.tileSize)
        let boundShiftY = Int(velocity.y / GlobalVars.tileSize)
        for x in (rasterizedX + (velocity.x > 0 ? -1 : (boundShiftX < -2 ? boundShiftX : -2)))...(rasterizedX + (velocity.x > 0 ? (boundShiftX > 2 ? boundShiftX : 2) : 2)) {
            for y in (rasterizedY + (velocity.y > 0 ? -1 : (boundShiftY < -2 ? boundShiftY : -2)))...(rasterizedY + (velocity.y > 0 ? (boundShiftY > 2 ? boundShiftY : 2) : 2)) {
                if x >= 0 && x < blocks.staticBlocks.count && y >= 0 && y < blocks.staticBlocks[0].count {
                    if let block = blocks.staticBlocks[x][y] {
                        collidable.append(block)
                    }
                }
            }
        }
        
        // orient dummy to detect horizontal collisions
        
        let velocityHigh = (velocity.x > velocity.y ? velocity.x : velocity.y)
        let divisions = Int(velocityHigh/GlobalVars.tileSize)
        var horizontalCollisions: [(block: Block, collision: (Bool, Bool))] = []
        var verticalCollisions: [(block: Block, collision: (Bool, Bool))] = []
        for z in 0...divisions {
            dummy.position = Point(x: self.position.x + GlobalVars.tileSize * Float(z) + self.velocity.x.truncatingRemainder(dividingBy: GlobalVars.tileSize), y: self.position.y)
            for block in collidable {
                if dummy.intersects(block) {
                    horizontalCollisions.append((block, (true, false)))
                }
            }
            
            // orient dummy to detect vertical collisions
            dummy.position = Point(x: self.position.x, y: self.position.y + GlobalVars.tileSize * Float(z) + self.velocity.y.truncatingRemainder(dividingBy: GlobalVars.tileSize))
            for block in collidable {
                if dummy.intersects(block) {
                    verticalCollisions.append((block, (false, true)))
                }
            }
        }
        
        /*
         Possible Cases:
            - No collisions -> Proceed
            - Single-direction collision -> Return blocks
            - Multi-direction collision -> Test for initial conflict and return respective blocks
        */
        
        switch (horizontalCollisions.isEmpty, verticalCollisions.isEmpty) {
        case (true, true):
            return []
        case (false, true):
            return horizontalCollisions
        case (true, false):
            return verticalCollisions
        case (false, false):
            // find distances between edges and calculate the "time" it would take for each directional collision
            // find the relevant coordinates of colliding sides
            let verticalEdge = self.position.x + self.size.width/2 * (self.velocity.x > 0 ? 1 : -1)
            let horizontalEdge = self.position.y + self.size.height/2 * (self.velocity.y > 0 ? 1 : -1)
            
            let blockVerticalEdge = horizontalCollisions[0].block.position.x + horizontalCollisions[0].block.size.width/2 * (self.velocity.x > 0 ? -1 : 1)
            let blockHorizontalEdge = verticalCollisions[0].block.position.y + verticalCollisions[0].block.size.height/2 * (self.velocity.y > 0 ? -1 : 1)
            
            // find the distances
            let xDistance = verticalEdge - blockVerticalEdge
            let yDistance = horizontalEdge - blockHorizontalEdge
            
            // find the "times"
            let xTime = abs(xDistance / self.velocity.x)
            let yTime = abs(yDistance / self.velocity.y)
            
            if xTime < yTime {
                return horizontalCollisions + verticalCollisions
            } else {
                return verticalCollisions + horizontalCollisions
            }
        }
    }
    
    func replicate() -> Player {
        let player = Player()
        player.spawn(in: gameScene, and: Node(), at: position, with: size)
        return player
    }
    
}
