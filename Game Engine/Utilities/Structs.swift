//
//  Structs.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/24/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import CoreGraphics

struct Point {
    var x: Float
    var y: Float
}

struct Size {
    var width: Float
    var height: Float
}

struct Color {
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    static func red() -> Color {
        return Color(r: 1, g: 0, b: 0, a: 1)
    }
    static func yellow() -> Color {
        return Color(r: 1, g: 1, b: 0, a: 1)
    }
    static func green() -> Color {
        return Color(r: 0, g: 1, b: 0, a: 1)
    }
    static func cyan() -> Color {
        return Color(r: 0, g: 1, b: 1, a: 1)
    }
    static func blue() -> Color {
        return Color(r: 0, g: 0, b: 1, a: 1)
    }
    static func magenta() -> Color {
        return Color(r: 1, g: 0, b: 1, a: 1)
    }
    static func white() -> Color {
        return Color(r: 1, g: 1, b: 1, a: 1)
    }
    static func black() -> Color {
        return Color(r: 0, g: 0, b: 0, a: 1)
    }
}

struct Light {
    var position: Vector2
    var color: Color
    var radius: Float
    var softness: Float
    var strength: Float
    func floatBuffer() -> [Float] {
        return [position.x, position.y, color.r, color.g, color.b, radius, softness, strength]
    }
}

struct Rectangle {
    var size: Size
    var color: Color
    func toVertices() -> [Vertex] {
        var vertices: [Vertex] = []
        vertices.append(Vertex(position: Vector3(x: -size.width/2, y: -size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: size.width/2, y: -size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: -size.width/2, y: size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: -size.width/2, y: size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: size.width/2, y: -size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: size.width/2, y: size.height/2, z: 0), color: color))
        return vertices
    }
    func toIndexedVertices() -> [Vertex] {
        var vertices: [Vertex] = []
        vertices.append(Vertex(position: Vector3(x: -size.width/2, y: -size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: size.width/2, y: -size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: -size.width/2, y: size.height/2, z: 0), color: color))
        vertices.append(Vertex(position: Vector3(x: size.width/2, y: size.height/2, z: 0), color: color))
        return vertices
    }
    func indices() -> [UInt16] {
        return [0, 1, 2, 2, 1, 3]
    }
}

struct Frame {
    var position: Point
    var size: Size
}

struct Instance {
    var position: Vector2
    var scale: Vector2
    var color: Color
    func floatBuffer() -> [Float] {
        return [position.x, position.y, scale.x, scale.y, color.r, color.g, color.b, color.a]
    }
}

extension CGPoint {
    func toPoint() -> Point {
        return Point(x: Float(self.x), y: Float(self.y))
    }
}

extension CGRect {
    func toRectangle() -> Rectangle {
        return Rectangle(size: self.size.toSize(), color: Color(r: 1, g: 1, b: 1, a: 1))
    }
}

extension CGSize {
    func toSize() -> Size {
        return Size(width: Float(self.width), height: Float(self.height))
    }
}
