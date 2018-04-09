//
//  GlobalVars.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/2/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal
import UIKit

class GlobalVars {
    
    static var device: MTLDevice! = nil
    static var currentScene: Scene! = nil {
        didSet {
            GlobalVars.activeUINode = nil
        }
    }
    static var tileSize: Float! = nil {
        didSet {
            GlobalVars.blockTypes = BlockTypes(sized: tileSize)
            GlobalVars.blockTypes.genBlocks()
        }
    }
    static var blockTypes: BlockTypes! = nil
    static var exitAction: () -> () = {}
    
    static var levelProgress: Int = 0
    
    weak static var currentViewController: UIViewController! = nil
    weak static var activeUINode: Node? = nil
    
}
