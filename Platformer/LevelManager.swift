//
//  LevelManager.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/26/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import Metal

class LevelManager {
    weak var gameScene: GameScene!
    // level data
    let levels = Levels()
    
    // misc vars
    var tileSize: Float!
    
    // player
    var blocks = Blocks()
    var player: Player = Player()
    
    // world
    let world = Node()
    
    init(parent gameScene: GameScene) {
        world.geometry.node = world
        world.geometry.dynamic = true
        world.sortZPosition = false
        self.gameScene = gameScene
        self.tileSize = gameScene.tileSize
        gameScene.addChild(world)
    }
    
    // dynamic blocks include coins and rising and falling platforms
    func removeResponsiveBlock(_ block: Block) {
        for (n, potentialMatch) in blocks.responsiveBlocks.enumerated() {
            if potentialMatch === block {
                blocks.responsiveBlocks.remove(at: n)
            }
        }
    }
    
    // MARK: Load Level
    func loadLevel(level: Int) {
        loadLevel(level: levels.data[level].blocks)
        levels.data[level].script(gameScene)
    }
    
    func loadLevel(_ level: Level) {
        loadLevel(level: level.level)
        gameScene.geometry.color = level.background
        gameScene.prepareAmbience(colored: level.ambience)
    }
    
    func loadLevel(level: [String]) {
        world.removeAllChildren()
        blocks.staticBlocks = [[Block?]](repeating: [Block?](repeating: nil, count: level.count), count: level[0].count)
        blocks.responsiveBlocks = []
        blocks.animateBlocks = []
        for (row, string) in level.reversed().enumerated() {
            for (column, char) in string.enumerated() {
                var optional: Block? = nil
                let position = Point(x: Float(column) * tileSize, y: Float(row) * tileSize)
                switch char {
                case "@":
                    player.spawn(in: gameScene, and: world, at: position, with: Size(width: tileSize*5/12-tileSize/50, height: tileSize*5/12-tileSize/200*3))
                case " ":
                    continue
                    
                default:
                    optional = GlobalVars.blockTypes.createOfSymbol(char)
                }
                if let block = optional {
                    block.spawn(at: position, in: world, size: Size(width: tileSize, height: tileSize))
                    if block.geometry.dynamic {
                        if !block.updates {
                            blocks.responsiveBlocks.append(block)
                        } else {
                            blocks.animateBlocks.append(block)
                        }
                    } else if block.updates {
                        blocks.animateBlocks.append(block)
                    } else {
                        blocks.staticBlocks[column][row] = block
                    }
                }
            }
        }
        player.dead = false
        player.gameScene.saveStateManager.setCheckpoint(with: blocks, and: player)
        
        for block in blocks.animateBlocks {
            for component in block.updateComponents {
                component.appendUpdate(to: gameScene)
            }
        }
        
    }
    
    func update(input: (left: Bool, right: Bool, jump: Bool)) {
        player.update(with: blocks, and: input)
        
        world.position.x = -player.position.x * world.scale.x
        world.position.y = -player.position.y * world.scale.y
    }
    
    func restore(saveState: SaveStateManager) {
        gameScene.updateLoops = []
        gameScene.appendMainUpdateLoop()
        
        world.removeAllChildren()
        
        let checkpoint = saveState.checkpointCopy()
        player.spawn(in: gameScene, and: world, at: saveState.position!, with: player.size)
        player.velocity = Vector2(x: 0, y: 0)
        
        blocks.staticBlocks = []
        for column in checkpoint.staticBlocks {
            var toAppend: [Block?] = []
            for optional in column {
                if let block = optional {
                    block.spawn(at: block.position, in: world, size: Size(width: gameScene.tileSize, height: gameScene.tileSize))
                    block.onUpdate()
                }
                toAppend.append(optional)
            }
            blocks.staticBlocks.append(toAppend)
        }
        
        blocks.responsiveBlocks = []
        for block in checkpoint.responsiveBlocks {
            block.spawn(at: block.position, in: world, size: Size(width: gameScene.tileSize, height: gameScene.tileSize))
            blocks.responsiveBlocks.append(block)
        }
        
        blocks.animateBlocks = []
        for block in checkpoint.animateBlocks {
            block.spawn(at: block.position, in: world, size: Size(width: gameScene.tileSize, height: gameScene.tileSize))
            blocks.animateBlocks.append(block)
        }
        
        for updatingBlock in blocks.animateBlocks {
            for component in updatingBlock.updateComponents {
                component.appendUpdate(to: gameScene)
            }
        }
    }
}

struct Blocks {
    var staticBlocks: [[Block?]] = []
    var responsiveBlocks: [Block] = []
    var animateBlocks: [Block] = []
}
