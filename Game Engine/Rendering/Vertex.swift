//
//  Vertex.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/24/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

struct Vertex {
    
    var position: Vector3
    var color: Color
    static let length = MemoryLayout.size(ofValue: Float(1)) * 8
    
    func floatBuffer() -> [Float] {
        return [position.x, position.y, position.z, 1, color.r, color.g, color.b, color.a]
    }
    
}
