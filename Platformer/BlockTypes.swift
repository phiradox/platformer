//
//  BlockTypes.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/16/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import SpriteKit

class BlockTypes {
    var blocks = [Character : (label: String, block: Block)]()
    var editorBlocks = [Character : (label: String, block: Block)]()
    let tileSize: Float
    
    init(sized tileSize: Float) {
        self.tileSize = tileSize
    }
    
    func genBlocks() {
        var block = Block()
        var editorVersion = Block()
        
        // Wall
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0.8, g: 0.8, b: 0.8, a: 1)
        block.addComponent(Solid(parent: block))
        block.label = "X"
        blocks["X"] = (label: "Wall", block: block)
        editorBlocks["X"] = (label: "Wall", block: block)
        
        // Grass
        
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0, g: 1, b: 0, a: 1)
        block.addComponent(Solid(parent: block))
        block.label = "G"
        blocks["G"] = (label: "Grass", block: block)
        editorBlocks["G"] = (label: "Grass", block: block)
        
        // Coin
        block = Block()
        block.geometry.node = block
        block.geometry.vertices = [
            Vertex(position: Vector3(0, -tileSize/2, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
            Vertex(position: Vector3(-tileSize/2, 0, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
            Vertex(position: Vector3(0, tileSize/2, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
            Vertex(position: Vector3(0, -tileSize/2, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
            Vertex(position: Vector3(0, tileSize/2, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
            Vertex(position: Vector3(tileSize/2, 0, 0), color: Color(r: 1, g: 1, b: 0, a: 1)),
        ]
        block.geometry.color = Color(r: 1, g: 1, b: 0, a: 1)
        block.addComponent(Coin(parent: block, value: 1))
        block.label = "O"
        blocks["O"] = (label: "Coin", block: block)
        editorBlocks["O"] = (label: "Coin", block: block)
        
        // Win
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
        block.addComponent(Win(for: block))
        block.label = "W"
        blocks["W"] = (label: "Win", block: block)
        editorBlocks["W"] = (label: "Win", block: block)
        
        // Lava
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 0, b: 0, a: 1)
        block.addComponent(Lava(parent: block))
        block.label = "!"
        blocks["!"] = (label: "Lava", block: block)
        editorBlocks["!"] = (label: "Lava", block: block)
        
        // Bottom
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0.671, g: 0.153, b: 0.31, a: 1)
        //block.addComponent(ZPosition(parent: block, zPosition: CGFloat(-1)))
        block.addComponent(SolidTop(parent: block))
        block.label = "B"
        blocks["B"] = (label: "Bottom", block: block)
        editorBlocks["B"] = (label: "Bottom", block: block)
        
        // Vanishing
        block = Block()
        block.geometry.node = block
        block.geometry.dynamic = true
        block.geometry.color = Color(r: 0.184, g: 0.518, b: 0.486, a: 1)
        block.addComponent(Solid(parent: block))
        block.addComponent(Vanish(parent: block))
        block.label = "V"
        blocks["V"] = (label: "Vanishing", block: block)
        editorBlocks["V"] = (label: "Vanishing", block: block)
        
        // Rising
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0.133, g: 0.188, b: 0.498, a: 1)
        block.addComponent(SolidTop(parent: block))
        block.addComponent(Rise(parent: block))
        block.label = "R"
        blocks["R"] = (label: "Rising", block: block)
        editorBlocks["R"] = (label: "Rising", block: block)
        
        // Falling
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 0.494, b: 0, a: 1)
        //block.addComponent(ZPosition(parent: block, zPosition: CGFloat(-1)))
        block.addComponent(Fall(parent: block))
        block.label = "F"
        blocks["F"] = (label: "Falling", block: block)
        editorBlocks["F"] = (label: "Falling", block: block)
        
        // Convey Right
        block = Block()
        block.geometry.node = block
        block.addComponent(Solid(parent: block))
        block.addComponent(Convey(Vector2(tileSize/40, 0), parent: block))
        block.geometry.vertices = [Vertex(position: Vector3(-tileSize/2, -tileSize/2, 0), color: Color(r: 0, g: 0, b: 0, a: 1)), Vertex(position: Vector3(-tileSize/2, tileSize/2, 0), color: Color(r: 0, g: 0, b: 0, a: 1)), Vertex(position: Vector3(tileSize/2, 0, 0), color: Color(r: 0, g: 0, b: 0, a: 1))]
        block.label = ">"
        blocks[">"] = (label: "Convey Right", block: block)
        editorBlocks[">"] = (label: "Convey Right", block: block)
        
        // Convey Left
        block = Block()
        block.geometry.node = block
        block.addComponent(Solid(parent: block))
        block.addComponent(Convey(Vector2(-tileSize/40, 0), parent: block))
        block.geometry.vertices = [Vertex(position: Vector3(tileSize/2, -tileSize/2, 0), color: Color(r: 0, g: 0, b: 0, a: 1)), Vertex(position: Vector3(tileSize/2, tileSize/2, 0), color: Color(r: 0, g: 0, b: 0, a: 1)), Vertex(position: Vector3(-tileSize/2, 0, 0), color: Color(r: 0, g: 0, b: 0, a: 1))]
        block.label = "<"
        blocks["<"] = (label: "Convey Left", block: block)
        editorBlocks["<"] = (label: "Convey Left", block: block)
        
        // Trampoline
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 0, b: 1, a: 1)
        block.addComponent(Bounce(parent: block))
        block.label = "T"
        blocks["T"] = (label: "Trampoline", block: block)
        editorBlocks["T"] = (label: "Trampoline", block: block)
        
        // Checkpoint
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0, g: 0, b: 0, a: 1)
        block.addComponent(SetSpawn(parent: block))
        block.label = "S"
        blocks["S"] = (label: "Checkpoint", block: block)
        editorBlocks["S"] = (label: "Checkpoint", block: block)
        
        // Ice
        block = Block()
        block.geometry.node = block
        block.addComponent(Friction(ofValue: Vector2(0.65, 1.0), for: block))
        block.addComponent(Solid(parent: block))
        block.geometry.color = Color(r: 0.6, g: 0.7, b: 1.0, a: 1.0)
        block.label = "I"
        blocks["I"] = (label: "Ice", block: block)
        editorBlocks["I"] = (label: "Ice", block: block)

            
        // Water
        block = Block()
        block.geometry.node = block
        block.addComponent(Friction(ofValue: Vector2(1.3, 2), for: block))
        block.geometry.color = Color(r: 0.0, g: 0.0, b: 1.0, a: 0.5)
        block.zPosition = 1
        block.addComponent(Water(for: block))
        block.label = "L"
        blocks["L"] = (label: "Water", block: block)
        editorBlocks["L"] = (label: "Water", block: block)

        
        // Mud
        block = Block()
        block.geometry.node = block
        block.addComponent(Friction(ofValue: Vector2(1.43, 1.25), for: block))
        block.addComponent(Solid(parent: block))
        block.geometry.color = Color(r: 0.5, g: 0.3, b: 0.1, a: 1.0)
        block.label = "M"
        editorBlocks["M"] = (label: "Mud", block: block)
        blocks["M"] = (label: "Mud", block: block)
        
        // Moving Lava Down
        block = Block()
        block.geometry.node = block
        block.addComponent(Lava(parent: block))
        if let gameScene = GlobalVars.currentScene as? GameScene {
            block.addComponent(Moving(by: Vector2(x: 0, y: GlobalVars.tileSize/20*2), for: block))
        }
        block.geometry.color = Color(r: 1, g: 0, b: 0, a: 1)
        block.label = "v"
        block.updates = true
        block.geometry.color = Color.red()
        blocks["v"] = (label: "Vertical Moving Lava Beginning Down", block: block)
        editorVersion = block.duplicate()
        editorVersion.geometry.vertices = [
            Vertex(position: Vector3(-tileSize/2, tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1)),
            Vertex(position: Vector3(0, -tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1)),
            Vertex(position: Vector3(tileSize/2, tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1))
        ]
        editorBlocks["v"] = (label: "Vertical Moving Lava Beginning Down", block: block)
        
        // Moving Lava Up
        block = Block()
        block.geometry.node = block
        block.addComponent(Lava(parent: block))
        if let gameScene = GlobalVars.currentScene as? GameScene {
            block.addComponent(Moving(by: Vector2(x: 0, y: -GlobalVars.tileSize/20*2), for: block))
        }
        block.geometry.color = Color(r: 1, g: 0, b: 0, a: 1)
        block.label = "^"
        block.updates = true
        block.geometry.color = Color.red()
        blocks["^"] = (label: "Vertical Moving Lava Beginning Up", block: block)
        editorVersion = block.duplicate()
        editorVersion.geometry.vertices = [
            Vertex(position: Vector3(-tileSize/2, -tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1)),
            Vertex(position: Vector3(0, tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1)),
            Vertex(position: Vector3(tileSize/2, -tileSize/2, 0), color: Color(r: 1, g: 0, b: 0, a: 1))
        ]
        editorBlocks["^"] = (label: "Vertical Moving Lava Beginning Up", block: editorVersion)
        
        // Quicksand
        block = Block()
        block.geometry.node = block
        block.addComponent(Friction(ofValue: Vector2(1.4, 3.0), for: block))
        block.geometry.color = Color(r: 0.8, g: 0.6, b: 0.4, a: 1.0)
        block.label = "~"
        editorBlocks["~"] = (label: "Quicksand", block: block)
        blocks["~"] = (label: "Quicksand", block: block)
        
        // Vines
        block = Block()
        block.geometry.node = block
        block.addComponent(Ground(for: block))
        block.addComponent(Friction(ofValue: Vector2(1, 10), for: block))
        block.addComponent(Solid(parent: block))
        block.geometry.color = Color(r: 0, g: 0.6, b: 0, a: 1)
        block.label = "="
        editorBlocks["="] = (label: "Vines", block: block)
        blocks["="] = (label: "Vines", block: block)
        
        // Moving Platform Left
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0.8, g: 0.8, b: 0.8, a: 1)
        block.addComponent(Solid(parent: block))
        block.addComponent(Moving(by: Vector2(-GlobalVars.tileSize/20*2, 0), for: block))
        block.label = "‹"
        block.updates = true
        blocks["‹"] = (label: "Moving Platform Starting Left", block: block)
        editorVersion = block.duplicate()
        editorVersion.geometry.vertices = [
            Vertex(position: Vector3(tileSize/2, -tileSize/2, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1)),
            Vertex(position: Vector3(tileSize/2, tileSize/2, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1)),
            Vertex(position: Vector3(-tileSize/2, 0, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1))
        ]
        editorBlocks["‹"] = (label: "Moving Platform Starting Left", block: editorVersion)
        
        // Moving Platform Right
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 0.8, g: 0.8, b: 0.8, a: 1)
        block.addComponent(Solid(parent: block))
        block.addComponent(Moving(by: Vector2(GlobalVars.tileSize/20*2, 0), for: block))
        block.label = "›"
        block.updates = true
        blocks["›"] = (label: "Moving Platform Starting Right", block: block)
        editorVersion = block.duplicate()
        editorVersion.geometry.vertices = [
            Vertex(position: Vector3(-tileSize/2, -tileSize/2, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1)),
            Vertex(position: Vector3(-tileSize/2, tileSize/2, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1)),
            Vertex(position: Vector3(tileSize/2, 0, 0), color: Color(r: 0.8, g: 0.8, b: 0.8, a: 1))
        ]
        editorBlocks["›"] = (label: "Moving Platform Starting Right", block: editorVersion)
        
        
        // Send to level blocks
        for i in 1...9 {
            block = Block()
            block.geometry.node = block
            block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
            block.addComponent(SendToLevel(i, relativeToCurrentLevel: true, parent: block))
            block.label = String(i)
            blocks[String(i).first!] = (label: "Send to level " + String(i), block: block)
        }
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
        block.addComponent(SendToLevel(10, relativeToCurrentLevel: true, parent: block))
        block.label = String("10")
        blocks["0"] = (label: "Send to level 10", block: block)
        
        // Next world block
        block = Block()
        block.geometry.node = block
        block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
        block.addComponent(SendToLevel(11, relativeToCurrentLevel: true, parent: block))
        block.label = String("Next Super World: 11")
        
        blocks["∞"] = (label: "Send to level 11", block: block)
    }
    
    func createOfSymbol(_ char: Character) -> Block? {
        var block: Block? = nil
        if let tuple = blocks[char] {
            block = tuple.block.duplicate()
        }
        return block
    }
}
