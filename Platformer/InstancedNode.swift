//
//  InstancedNode.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/28/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal

class InstancedNode: Node {
    
    var instances: [Instance] = []
    var stride: Int = MemoryLayout<Float>.stride * 8
    var instancesBuffer: MTLBuffer! = nil
    
    var indexCount: (Int?, Int?) = (nil, nil)
    var indexType: MTLIndexType! = MTLIndexType.uint16
    var indexBuffer: MTLBuffer! = nil
    
    func compileBuffers(with device: MTLDevice) {
        var floatBuffer: [Float] = []
        for node in instances {
            floatBuffer.append(contentsOf: node.floatBuffer())
        }
        instancesBuffer = device.makeBuffer(bytes: floatBuffer, length: MemoryLayout<Float>.stride * floatBuffer.count, options: [])
    }
    
    func changeNode(at index: Int, to newData: Instance) {
        instances[index] = newData
        if let buffer = instancesBuffer {
            memcpy(buffer.contents() + index*stride, newData.floatBuffer(), stride)
        }
    }
    
}
