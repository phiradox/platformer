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
        
        var dynamicCopy: [Block] = []
        for block in blocks.dynamicBlocks {
            dynamicCopy.append(block.duplicate())
        }
        
        return Blocks(staticBlocks: staticCopy, dynamicBlocks: dynamicCopy)
    }
    
    func checkpointCopy() -> Blocks {
        return copy(level: checkpoint!)
    }
    
    func setCheckpoint(with state: Blocks, and player: Player) {
        checkpoint = state
        position = player.position
    }
    
}
