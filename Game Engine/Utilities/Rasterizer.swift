//
//  Rasterizer.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/15/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import SpriteKit

class Rasterizer {
    
    static func rasterize(_ array: [String], repeating block: Block, sized tileSize: Float, in node: Node) {
        let width = Float(array.first!.count) * tileSize
        let height = Float(array.count) * tileSize
        node.size = Size(width: width, height: height)
        for (y, row) in array.reversed().enumerated() {
            for (x, char) in row.enumerated() {
                if char != " " {
                    let block = block.duplicate()
                    block.spawn(at: Point(x: (Float(x)+0.5) * tileSize - width/2, y: (Float(y)+0.5) * tileSize - height/2), in: node, size: Size(width: tileSize, height: tileSize))
                }
            }
        }
    }
    
    static func rasterize(_ array: [String], repeating block: Block, sized tileSize: Float, in node: Node, offset: Point) {
        let width = Float(array.first!.count) * tileSize
        let height = Float(array.count) * tileSize
        node.size = Size(width: width, height: height)
        for (y, row) in array.reversed().enumerated() {
            for (x, char) in row.enumerated() {
                if char != " " {
                    let block = block.duplicate()
                    block.spawn(at: Point(x: (Float(x)+0.5) * tileSize - width/2 + offset.x, y: (Float(y)+0.5) * tileSize - height/2 + offset.y), in: node, size: Size(width: tileSize, height: tileSize))
                }
            }
        }
    }
    
    static func rasterizeWithGradient(_ array: [String], from: Color, to: Color, sized tileSize: Float, in node: Node) {
        let width = Float(array.first!.count) * tileSize
        let height = Float(array.count) * tileSize
        node.size = Size(width: width, height: height)
        for (y, row) in array.reversed().enumerated() {
            for (x, char) in row.enumerated() {
                if char != " " {
                    if let magnitudeInt = Int(String(char)) {
                        let magnitude = Float(magnitudeInt)
                        let color = Color(r: from.r + (to.r - from.r)/10*magnitude, g: from.g + (to.g - from.g)/10*magnitude, b:
                        from.b + (to.b - from.b)/10*magnitude, a: from.a + (to.a - from.a)/10*magnitude)
                        let block = Block()
                        block.spawn(at: Point(x: Float(x) * tileSize - width/2, y: Float(y) * tileSize - height/2), in: node, size: Size(width: tileSize, height: tileSize))
                        block.geometry.color = color
                    }
                }
            }
        }
    }
}
