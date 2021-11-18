//
//  Renderer.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/24/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal

class Renderer {
    
    var device: MTLDevice! = nil
    
    var encoder: MTLRenderCommandEncoder! = nil
    
    var projectionMatrix: [Float]! = nil
    var transformationMatricesBuffers: BufferManager! = nil
    
    init(with device: MTLDevice, projectionMatrix: [Float]) {
        self.device = device
        self.projectionMatrix = projectionMatrix
        // buffer size is equal to the size of the projection and two model matrices
        self.transformationMatricesBuffers = BufferManager(device: device, bufferCount: 2048, bufferSize: 48 * MemoryLayout<Float>.stride)
    }
    
    func initEncoder(with commandBuffer: MTLCommandBuffer, and renderPassDescriptor: MTLRenderPassDescriptor, and renderPipelineState: MTLRenderPipelineState) {
        self.encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        self.encoder.setRenderPipelineState(renderPipelineState)
    }
    
    func renderMaster(_ node: Node, withChildren: Bool) {
        if node.isDirty {
            node.calculateScreenMatrix()
        }
        if node.geometry.masterBuffer == nil && !node.geometry.isEmpty {
            if node.geometry.node == nil {
                node.geometry.node = node
            }
            node.geometry.masterCompile()
        }
        if node.geometry.isDirty {
            node.geometry.masterCompile()
        }
        var viewTransformation: [Float] = []
        if let dynamicParent = node.geometry.getDynamicParent() {
            if dynamicParent.isDirty || dynamicParent.transformationToScreen == nil {
                dynamicParent.calculateScreenMatrix()
            }
            viewTransformation = dynamicParent.transformationToScreen.toArray()
        } else {
            viewTransformation = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        }
        let uniformsBuffer = transformationMatricesBuffers.nextUniformsBuffer(of: projectionMatrix, and: viewTransformation, and: node.transformation.toArray())
        if let masterBuffer = node.geometry.masterBuffer {
            encoder.setVertexBuffer(uniformsBuffer, offset: 0, index: 1)
            encoder.setVertexBuffer(masterBuffer, offset: 0, index: 0)
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: node.geometry.masterBuffer!.length / Vertex.length)
        }
        if withChildren {
            for child in node.children {
                render(child)
            }
        }
    }
    
    func render(_ node: Node) {
        if node.geometry.dynamic {
            renderMaster(node, withChildren: true)
        } else {
            for child in node.children {
                render(child)
            }
        }
    }
    
    func endEncoding(with device: MTLDevice) {
        encoder.endEncoding()
    }
    
}
