//
//  SaveStateManager.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/9/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import SpriteKit

class SaveStateManager {
    
    // Managed States
    var checkpoint: Blocks? = nil
    var position: Point? = nil
    
    // scene to append update loops to
    var scene: Scene! = nil
    
    func copy(level blocks: Blocks) -> Blocks {
        var staticCopy: [[Block?]] = []
        for column in blocks.staticBlocks {
            var columnCopy: [Block?] = []
            for optional in column {
                if let block = optional {
                    columnCopy.append(block.duplicate())
                } else {
                    columnCopy.append(nil)
                }
            }
            staticCopy.append(columnCopy)
        }
        
        var responsiveBlocksCopy: [Block] = []
        for block in blocks.responsiveBlocks {
            responsiveBlocksCopy.append(block.duplicate())
        }
        
        var animateBlocksCopy: [Block] = []
        for block in blocks.animateBlocks {
            animateBlocksCopy.append(block.duplicate())
        }
        
        return Blocks(staticBlocks: staticCopy, responsiveBlocks: responsiveBlocksCopy, animateBlocks: animateBlocksCopy)
    }
    
    func checkpointCopy() -> Blocks {
    return copy(level: checkpoint!)
    }
    
    func setCheckpoint(with state: Blocks, and player: Player) {
        checkpoint = state
        position = player.position
    }
    
}
