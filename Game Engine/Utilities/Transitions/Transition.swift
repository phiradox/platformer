//
//  Transition.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/31/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

class Transition {
    
    var oldNode: Node
    var newNode: Node
    
    var duration: Int
    var currentTick: Int
    var callback: () -> () = {}
    
    init(from oldNode: Node, to newNode: Node, duration seconds: Float, onCompletion callback: @escaping () -> ()) {
        self.oldNode = oldNode
        self.newNode = newNode
        self.duration = Int(seconds*60)
        self.currentTick = 0
        self.callback = callback
    }
    
    func update() {
        currentTick += 1
        if currentTick >= duration {
            callback()
        }
    }
    
    static func sinSum(increments: Int) -> Float {
        var total: Float = 0
        for x in 0...increments {
            total += sin(Float(x)*Float.pi/60)
        }
        return total
    }
    
}
