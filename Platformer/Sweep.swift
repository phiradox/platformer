//
//  Sweep.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/31/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation


class Sweep: Transition {
    var targetPoition: Point
    var distance: Point
    var sinSum: Float
    
    init(from oldNode: Node, origin: Bool, to newNode: Node, duration seconds: Float, onCompletion callback: @escaping () -> ()) {
        if origin {
            self.distance = Point(x: -newNode.position.x, y: -newNode.position.y)
        } else {
            self.distance = Point(x: oldNode.position.x - newNode.position.x, y: oldNode.position.y - newNode.position.y)
        }
        self.targetPoition = oldNode.position
        self.sinSum = Transition.sinSum(increments: Int(seconds*60))
        super.init(from: oldNode, to: newNode, duration: seconds, onCompletion: callback)
    }
    
    override func update() {
        super.update()
        if currentTick > duration {
            newNode.position = targetPoition
        }
        let change = Point(x: distance.x/sinSum*sin(Float(currentTick)/Float(duration)*Float.pi), y: distance.y/sinSum*sin(Float(currentTick)/Float(duration)*Float.pi))
        newNode.position.x += change.x
        newNode.position.y += change.y
        oldNode.position.x += change.x
        oldNode.position.y += change.y
    }
    
}
