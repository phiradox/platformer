//
//  Geometry.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/10/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import Metal

class Geometry {
    var dynamic: Bool = false
    
    var masterFloatBuffer: [Float]? = nil
    var masterBuffer: MTLBuffer? = nil
    
    var isDirty: Bool = false
    
    var isEmpty: Bool = false
    
    var vertices: [Vertex] = [] {
        didSet {
            //node?.size = calculateSize()
            //bufferVertices()
            isDirty = true
        }
    }
    var floatBuffer: [Float] = []
    
    var color: Color = Color(r: 1, g: 1, b: 1, a: 1) {
        didSet {
            for (i, _) in vertices.enumerated() {
                vertices[i].color = color
            }
            bufferVertices()
            isDirty = true
        }
    }
    
    weak var node: Node? = nil {
        didSet {
            //node?.size = calculateSize()
        }
    }
    
    private var dynamicParent: Node? = nil
    
    init() {
        vertices = []
    }
    
    init(of node: Node) {
        self.node = node
    }
    
    func calculateSize() -> Size {
        var minX: Float = 0
        var minY: Float = 0
        var maxX: Float = 0
        var maxY: Float = 0
        for vertex in vertices {
            if vertex.position.x < minX {
                minX = vertex.position.x
            }
            if vertex.position.y < minY {
                minY = vertex.position.y
            }
            if vertex.position.x > maxX {
                maxX = vertex.position.x
            }
            if vertex.position.y > maxY {
                maxY = vertex.position.y
            }
        }
        return Size(width: maxX - minX, height: maxY - minY)
    }
    
    func bufferVertices() {
        floatBuffer = []
        for vertex in vertices {
            floatBuffer.append(contentsOf: vertex.floatBuffer())
        }
    }
    
    func masterCompile() {
        node!.calculateMatrix()
        masterFloatBuffer = []
        masterFloatBuffer!.append(contentsOf: compile(with: GlobalVars.device))
        if masterFloatBuffer!.isEmpty {
            isEmpty = true
        } else {
            isEmpty = false
        }
        if !masterFloatBuffer!.isEmpty {
            masterBuffer = GlobalVars.device.makeBuffer(bytes: masterFloatBuffer!, length: masterFloatBuffer!.count * MemoryLayout.size(ofValue: Float(1)), options: [])
        }
        isDirty = false
        node!.isDirty = false
    }
    
    func compileSelf() {
        var selfBuffer: [Float] = []
        node!.calculateMatrix()
        if (vertices.count > 0) {
            for index in 0...self.vertices.count-1 {
                var vertex = vertices[index]
                if !dynamic {
                    vertex.position = vertex.position * node!.transformation
                }
                selfBuffer.append(contentsOf: vertex.floatBuffer())
            }
        }
        memcpy(masterBuffer!.contents(), selfBuffer, selfBuffer.count * MemoryLayout.size(ofValue: Float(1)))
    }
    
    func compile(with device: MTLDevice) -> [Float] {
        var returnBuffer: [Float] = []
        node!.calculateMatrix()
        if (vertices.count > 0) {
            for index in 0...self.vertices.count-1 {
                var vertex = vertices[index]
                if !dynamic {
                    vertex.position = vertex.position * node!.transformation
                }
                returnBuffer.append(contentsOf: vertex.floatBuffer())
            }
        }
        for child in node!.children {
            if child.geometry.node == nil {
                child.geometry.node = child
            }
            if !child.geometry.dynamic {
                returnBuffer.append(contentsOf: child.geometry.compile(with: device))
            } else {
                child.geometry.masterCompile()
            }
        }
        
        return returnBuffer
    }
    
    func getDynamicParent() -> Node? {
        if let parent = dynamicParent {
            return parent
        } else if node!.hasParent() {
            if node!.parent!.geometry.dynamic {
                dynamicParent = node!.parent!
            } else {
                dynamicParent = node!.parent!.geometry.getDynamicParent()
            }
            return dynamicParent
        } else {
            return nil
        }
    }
    
}

infix operator >!<

func >!< (object1: AnyObject!, object2: AnyObject!) -> Bool {
    return (object_getClassName(object1) == object_getClassName(object2))
}
