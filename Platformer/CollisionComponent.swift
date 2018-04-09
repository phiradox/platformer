//
//  CollisionComponent.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/11/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import SpriteKit

// MARK: Foundational Protocol
protocol CollisionComponent {
    func onCollision(with player: Player) -> Bool
    func duplicate(forParent parent: Block) -> CollisionComponent?
    weak var parent: Block! { get }
}


// MARK: Solid Sides
class SolidLeft: CollisionComponent {
    weak internal var parent: Block!

    internal func onCollision(with player: Player) -> Bool {
        if player.collision.horizontal && player.velocity.x < 0 && player.position.x > parent.position.x + parent.size.width/2 + player.size.width/2 {
            player.velocity.x = 0
            player.position.x = parent.position.x + parent.size.width/2 + player.size.width/2 + 0.01
        }
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SolidLeft(parent: parent)
    }
    
}

class SolidRight: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        if player.collision.horizontal && player.velocity.x > 0 && player.position.x < parent.position.x - parent.size.width/2 - player.size.width/2 {
            player.velocity.x = 0
            player.position.x = parent.position.x - parent.size.width/2 - player.size.width/2 - 0.01
        }
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SolidRight(parent: parent)
    }
}

class SolidBottom: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        if player.collision.vertical && player.velocity.y > 0 && player.position.y < parent.position.y - parent.size.height/2 - player.size.height/2  {
            player.velocity.y = 0
            player.position.y = parent.position.y - parent.size.height/2 - player.size.height/2 - 0.01
        }
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SolidBottom(parent: parent)
    }
}

class SolidTop: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        if player.collision.vertical && player.velocity.y < 0 && player.position.y > parent.position.y + player.size.width/2 + parent.size.width/2 {
            player.velocity.y = 0
            player.position.y = parent.position.y + parent.size.height/2 + player.size.height/2 + 0.01
            player.ground = true
        }
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SolidTop(parent: parent)
    }
}

class Solid: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        return true
    }
    
    init(parent: Block) {
        parent.addComponent(SolidTop(parent: parent))
        parent.addComponent(SolidBottom(parent: parent))
        parent.addComponent(SolidLeft(parent: parent))
        parent.addComponent(SolidRight(parent: parent))
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return nil
    }
}

// MARK: Function Blocks

class Coin: CollisionComponent {
    weak internal var parent: Block!
    var value: Int!
    
    internal func onCollision(with player: Player) -> Bool {
        player.coins += value
        parent.removeFromParent()
        let rastPos = (x: Int(parent.position.x / player.gameScene.tileSize), y: Int(parent.position.y / player.gameScene.tileSize))
        player.gameScene.levelManager.blocks.staticBlocks[rastPos.x][rastPos.y] = nil
        return true
    }
    
    init(parent: Block, value: Int) {
        self.parent = parent
        self.value = value
        self.parent.geometry.dynamic = true
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Coin(parent: parent, value: self.value)
    }
}

class SendToLevel: CollisionComponent {
    weak internal var parent: Block!
    var level: Int!
    var relativeToCurrentLevel: Bool
    
    internal func onCollision(with player: Player) -> Bool {
        if relativeToCurrentLevel {
            player.gameScene.level += level
        } else {
            player.gameScene.level = level
        }
        player.gameScene.saveStateManager.setCheckpoint(with: player.gameScene.saveStateManager.copy(level: player.gameScene.levelManager.blocks), and: player)
        return false
    }
    
    init(_ level: Int, relativeToCurrentLevel: Bool, parent: Block) {
        self.parent = parent
        self.relativeToCurrentLevel = relativeToCurrentLevel
        self.level = level
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SendToLevel(self.level, relativeToCurrentLevel: relativeToCurrentLevel, parent: parent)
    }
}

class Win: CollisionComponent {
    weak internal var parent: Block!
    var level: Int!
    
    internal func onCollision(with player: Player) -> Bool {
        if player.gameScene.level > GlobalVars.levelProgress {
            GlobalVars.levelProgress = player.gameScene.level
        }
        GlobalVars.blockTypes.genBlocks()
        player.gameScene.level += 1
        player.gameScene.saveStateManager.setCheckpoint(with: player.gameScene.saveStateManager.copy(level: player.gameScene.levelManager.blocks), and: player)
        return false
    }
    
    init(for parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Win(for: parent)
    }
}

class Lava: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        player.dead = true
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Lava(parent: parent)
    }
}

class Vanish: CollisionComponent {
    weak internal var parent: Block!
    var opacity: Float = 1.0
    
    internal func onCollision(with player: Player) -> Bool {
        opacity -= 0.03
        if opacity < 0 {
            opacity = 0
            parent.removeFromParent()
            player.gameScene.levelManager.removeDynamicBlock(self.parent)
        }
        parent.geometry.color.a = opacity
        return true
    }
    
    init(parent: Block) {
        self.parent = parent
        self.parent.geometry.dynamic = true
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Vanish(parent: parent)
    }
}

class Rise: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        parent.position.y += 1 * GlobalVars.tileSize/20
        if player.ground == true {
            player.position.y = parent.position.y + parent.size.height/2 + player.size.height/2
        }
        return true
    }
    
    init(parent: Block) {
        self.parent = parent
        self.parent.geometry.dynamic = true
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Rise(parent: parent)
    }
}

class Fall: CollisionComponent {
    weak internal var parent: Block!
    private var dropRate: Float = 0.5 * GlobalVars.tileSize / 20
    
    internal func onCollision(with player: Player) -> Bool {
        if player.position.y > parent.position.y - dropRate + parent.size.width/2 + player.size.height/2 {
            if player.velocity.y < -dropRate {
                player.velocity.y = -dropRate
            }
            player.ground = true
            parent.position.y -= dropRate
        } else if player.velocity.y < 0 {
            parent.position.y -= dropRate*4
        }
        
        return true
    }
    
    init(parent: Block) {
        self.parent = parent
        self.parent.geometry.dynamic = true
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Fall(parent: parent)
    }
}

class Convey: CollisionComponent {
    weak internal var parent: Block!
    // the speed of the conveyer
    var speed: Vector2!
    
    // add that speed when collided
    internal func onCollision(with player: Player) -> Bool {
        player.velocity.x += speed.x
        player.velocity.y += speed.y
        return false
    }
    
    // initiallize with a certain conveyer speed
    init(_ speed: Vector2, parent: Block) {
        self.parent = parent
        self.speed = speed
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Convey(self.speed, parent: parent)
    }
}

class Bounce: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        // check the directions in which bounced have occured, and set that to be true afterwards if false to prevent conflictions
        
        if !player.bounced.vertical && player.collision.vertical {
            
            var donotexecute = false
            
            // if the player is travelling upwards
            if player.velocity.y > 0 {
                // just flip the velocity
                player.velocity.y = -player.velocity.y
                
                // position the player just below the block
                player.position.y = parent.position.y - parent.size.height/2 - player.size.height/2 - 0.1
                donotexecute = true
            }
            
            // if the player is travelling downwards
            if !donotexecute && player.velocity.y < 0 {
                // flip the velocity, and if the jump input is true than propel the player higher
                player.velocity.y = player.input.jump ? -player.velocity.y + player.velocityConstants[3] : -player.velocity.y
                
                // position the player just above the block
                player.position.y = parent.position.y + parent.size.height/2 + player.size.height/2 + 0.1
            }
            // set bounced horizontal to true
            player.bounced.vertical = true
        }
        
        if !player.bounced.horizontal && player.collision.horizontal {
            
            var donotexecute = false
            
            if player.velocity.x > 0 {
                // flip the velocity and if the rightwards input is true than propel the player faster to the left
                player.velocity.x = player.input.right ? -player.velocity.x - player.velocityConstants[3] : -player.velocity.x
                // position the player just the left of the block
                player.position.x = parent.position.x - parent.size.width/2 - player.size.width/2 - 0.1
                donotexecute = true
            }
            
            // if the player is travelling to the left
            if !donotexecute && player.velocity.x < 0 {
                // flip the velocity and if the leftwards input is true than propel the player faster to the right
                player.velocity.x = player.input.left ? -player.velocity.x + player.velocityConstants[3] : -player.velocity.x
                // position the player just to the right of the block
                player.position.x = parent.position.x + parent.size.width/2 + player.size.width/2 + 0.1
            }
            
            // set bounced horizontal to true
            player.bounced.horizontal = true
        }
        
        return false
    }
    
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Bounce(parent: parent)
    }
}

class SetSpawn: CollisionComponent {
    weak internal var parent: Block!
    
    // set new spawn point when player touches block
    internal func onCollision(with player: Player) -> Bool {
        // create a new rainbow block and delete this one
        let replacer = Block()
        //replacer.addComponent(Rainbow(parent: replacer))
        replacer.spawn(at: parent.position, in: player.gameScene.levelManager.world, size: parent.size)
        replacer.onUpdate()
        let rastPos = (x: Int(parent.position.x / player.gameScene.tileSize), y: Int(parent.position.y / player.gameScene.tileSize))
        parent.removeFromParent()
        player.gameScene.levelManager.blocks.staticBlocks[rastPos.x][rastPos.y] = replacer
        player.gameScene.saveStateManager.setCheckpoint(with: player.gameScene.saveStateManager.copy(level: player.gameScene.levelManager.blocks), and: player)
        return true
    }
    
    // initiallize
    init(parent: Block) {
        self.parent = parent
        self.parent.geometry.dynamic = true
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return SetSpawn(parent: parent)
    }
}

class Trigger: CollisionComponent {
    weak internal var parent: Block!
    var closure: (_ gameScene: GameScene) -> () = { (_ gameScene: GameScene) -> () in }
    
    // trigger a closure when the block is touched
    internal func onCollision(with player: Player) -> Bool {
        closure(player.gameScene)
        return true
    }
    
    // initialize
    init(parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        let duplicate = Trigger(parent: parent)
        duplicate.closure = self.closure
        return duplicate
    }
}

class Friction: CollisionComponent {
    weak internal var parent: Block!
    var friction: Vector2!
    
    internal func onCollision(with player: Player) -> Bool {
        player.friction = friction
        return false
    }
    
    init(ofValue friction: Vector2, for parent: Block) {
        self.parent = parent
        self.friction = friction
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Friction(ofValue: self.friction, for: parent)
    }
}

class Water: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        player.water = true
        return false
    }
    
    init(for parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Water(for: parent)
    }
}

class Ground: CollisionComponent {
    weak internal var parent: Block!
    
    internal func onCollision(with player: Player) -> Bool {
        player.ground = true
        return false
    }
    
    init(for parent: Block) {
        self.parent = parent
    }
    
    internal func duplicate(forParent parent: Block) -> CollisionComponent? {
        return Ground(for: parent)
    }
}
