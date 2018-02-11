//
//  Ambience.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/28/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal

class Ambience: InstancedNode {
    
    var indexUInt16Buffer: [UInt16] = [0, 1, 2, 2, 1, 3]
    
    func generateParticles(numbered numberOfParticles: Int, from position1: Vector2, to position2: Vector2, from scale1: Vector2, to scale2: Vector2, from color1: Color, to color2: Color) {
        for _ in 0...numberOfParticles-1 {
            var position = Vector2(position1.x + Float(arc4random_uniform(UInt32(position2.x - position1.x))), position1.y + Float(arc4random_uniform(UInt32(position2.y - position1.y))))
            var scale = Vector2(scale1.x + Float(arc4random_uniform(UInt32(scale2.x - scale1.x)*1000))/1000, scale1.y + Float(arc4random_uniform(UInt32(scale2.y - scale1.y)*1000))/1000)
            scale.y = scale.x
            position.x *= (scale.x * scale.y)
            position.y *= (scale.x * scale.y)
            let color = Color(r: Float(UInt32(255*color1.r) + arc4random_uniform(UInt32(255*(color2.r-color1.r))))/255, g: Float(UInt32(255*color1.g) + arc4random_uniform(UInt32(255*(color2.g-color1.g))))/255, b: Float(UInt32(255*color1.b) + arc4random_uniform(UInt32(255*(color2.b-color1.b))))/255, a: Float(UInt32(255*color1.a) + arc4random_uniform(UInt32(255*(color2.a-color1.a))))/255)
            instances.append(Instance(position: position, scale: scale, color: color))
        }
        geometry.dynamic = true
    }
    
    override func compileBuffer(with device: MTLDevice) {
        super.compileBuffer(with: device)
        indexBuffer = device.makeBuffer(bytes: indexUInt16Buffer, length: MemoryLayout<UInt16>.stride * indexUInt16Buffer.count, options: [])
        indexCount = 6
    }
}
