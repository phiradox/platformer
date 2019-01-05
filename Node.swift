//
//  Node.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/23/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

class Node {
    
    // MARK: VARS
    var position: Point = Point(x: 0, y: 0) {
        didSet {
            isDirty = true
        }
    }
    var rotation: Float = 0 {
        didSet {
            isDirty = true
        }
    }
    var scale: Vector2 = Vector2(1, 1) {
        didSet {
            isDirty = true
        }
    }
    
    var screenPosition: Point {
        get {
            if let parent = self.parent {
                let parentScreenPosition = parent.screenPosition
                return Point(x: self.position.x + parentScreenPosition.x, y: self.position.y + parentScreenPosition.y)
            } else {
                return self.position
            }
        }
    }
    
    var size: Size = Size(width: 0, height: 0)
    var zPosition: Float = 0
    var sortZPosition: Bool = true
    var transformation: Matrix4! = nil
    var transformationToScreen: Matrix4! = nil
    var isDirty: Bool = true
    
    var label: String? = nil
    
    var geometry: Geometry = Geometry()
    
    weak var parent: Node? = nil {
        didSet {
            if let parent = self.parent {
                parent.children.append(self)
            }
        }
    }
    var children: [Node] = [] {
        didSet {
            if sortZPosition {
                children.sort(by: {(childA, childB) -> Bool in
                    return childA.zPosition > childB.zPosition
                })
            }
        }
    }
    
    // MARK: CONSTRUCTORS
    init() {
        
    }
    
    // MARK: FUNCTIONS
    
    func addChild(_ child: Node) {
        child.parent = self
    }
    
    func intersects(_ node: Node) -> Bool {
        return (abs(position.x - node.position.x) * 2 < (size.width + node.size.width)) &&
            (abs(position.y - node.position.y) * 2 < (size.height + node.size.height))
    }
    
    func contains(_ point: Point) -> Bool {
        return !(point.x < position.x - size.width/2 || point.x > position.x + size.width/2 || point.y < position.y - size.height/2 || point.y > position.y + size.height/2)
    }
    
    func contains(pointRelativeToScreen point: Point) -> Bool {
        let position = screenPosition
        return !(point.x < position.x - size.width/2 || point.x > position.x + size.width/2 || point.y < position.y - size.height/2 || point.y > position.y + size.height/2)
    }
    
    enum Relativity {
        case screen
        case nodeSelf
    }
    
    func nodes(at point: Point, relativeTo relativity: Relativity) -> [Node] {
        var nodes: [Node] = []
        for child in children.reversed() {
            if relativity == .nodeSelf {
                if child.contains(point) {
                    nodes.append(child)
                }
                nodes.append(contentsOf: child.nodes(at: Point(x: point.x + position.x, y: point.y + position.y), relativeTo: .nodeSelf))
            } else {
                let screenPosition = self.screenPosition
                if child.contains(Point(x: point.x - screenPosition.x, y: point.y - screenPosition.y)) {
                    nodes.append(child)
                }
                nodes.append(contentsOf: child.nodes(at: point, relativeTo: .screen))
            }
            
        }
        return nodes
    }
    
    func removeAllChildren() {
        for child in children {
            child.removeFromParent()
        }
    }
    
    func removeFromParent() {
        let optional = parent?.children.index(where: {(node) -> Bool in
            return (node === self)
        })
        if let index = optional {
            parent?.children.remove(at: index)
        }
        parent = nil
    }
    
    func hasParent() -> Bool {
        return (parent != nil)
    }
    
    func calculateMatrix() {
        parent?.calculateMatrix()
        if self.hasParent() && !parent!.geometry.dynamic {
            if parent!.isDirty {
                parent?.calculateMatrix()
            }
            if parent!.geometry.dynamic {
                transformation =
                    Matrix4(translation: Vector3(position.x, position.y, 0)) *
                    Matrix4(scale: Vector3(scale.x, scale.y, 1)) *
                    Matrix4(rotation: Vector4(rotation, 0, 0, 0))
            } else {
                transformation =
                    Matrix4(translation: Vector3(position.x, position.y, 0)) *
                    Matrix4(scale: Vector3(scale.x, scale.y, 1)) *
                    Matrix4(rotation: Vector4(rotation, 0, 0, 0)) * parent!.transformation
            }
        } else {
            transformation =
                Matrix4(translation: Vector3(position.x, position.y, 0)) *
                Matrix4(scale: Vector3(scale.x, scale.y, 1)) *
                Matrix4(rotation: Vector4(rotation, 0, 0, 0))
        }
        isDirty = false
    }
    
    func calculateScreenMatrix() {
        calculateMatrix()
        parent?.calculateScreenMatrix()
        transformationToScreen =
                Matrix4(translation: Vector3(position.x, position.y, 0)) *
                Matrix4(scale: Vector3(scale.x, scale.y, 1)) *
            Matrix4(rotation: Vector4(rotation, 0, 0, 0)) * (self.hasParent() ? parent!.transformationToScreen : Matrix4([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]))
    }
    
}
