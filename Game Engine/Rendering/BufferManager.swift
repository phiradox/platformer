//
//  BufferManager.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/24/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal

class BufferManager {
    
    let bufferCount: Int
    let bufferSize: Int
    private var buffers: [MTLBuffer] = []
    private var bufferIndex: Int = 0
    var device: MTLDevice! = nil
    let floatStride = MemoryLayout<Float>.stride
    
    init(device: MTLDevice, bufferCount: Int, bufferSize: Int) {
        self.bufferCount = bufferCount
        self.bufferSize = bufferSize
        self.device = device
        
        for _ in 0...bufferCount-1 {
            let uniformsBuffer = device.makeBuffer(length: bufferSize, options: [])
            self.buffers.append(uniformsBuffer!)
        }
    }
    
    func nextUniformsBuffer(ofData data: [Float]) -> MTLBuffer {
        let buffer = buffers[bufferIndex]
        let bufferPointer = buffer.contents()
        
        memcpy(bufferPointer, data, bufferSize)
        
        bufferIndex += 1
        if bufferIndex == bufferCount {
            bufferIndex = 0
        }
        
        return buffer
    }
    
    func nextUniformsBuffer(ofData data: [[Float]]) -> MTLBuffer {
        let buffer = buffers[bufferIndex]
        let bufferPointer = buffer.contents()
        
        var incrementedPointer: Int = 0
        for array in data {
            let size = array.count*floatStride
            memcpy(bufferPointer + incrementedPointer, array, size)
            incrementedPointer += size
        }
        
        bufferIndex += 1
        if bufferIndex == bufferCount {
            bufferIndex = 0
        }
        
        return buffer
    }
    
    func nextUniformsBuffer(of matrix1: [Float], and matrix2: [Float], and matrix3: [Float]) -> MTLBuffer {
        let buffer = buffers[bufferIndex]
        let bufferPointer = buffer.contents()
        
        let size = 16*floatStride
        memcpy(bufferPointer, matrix1, size)
        memcpy(bufferPointer + size, matrix2, size)
        memcpy(bufferPointer + 2*size, matrix3, size)
        
        bufferIndex += 1
        if bufferIndex == bufferCount {
            bufferIndex = 0
        }
        
        return buffer
    }
    
}
