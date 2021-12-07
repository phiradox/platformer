//
//  Color Picker.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/7/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

class ColorPicker: Node, TouchDelegate {
    
    var scene: Scene! = nil
    var saturationBrightnessTriangle: Node! = nil
    var hueRectangle: Node! = nil
    var previewCircle: Node! = nil
    var okButton: Button! = nil
    var containerNode: Node = Node()
    
    let colors: [Int:Color] = [
        0 : Color.red(),
        1 : Color.yellow(),
        2 : Color.green(),
        3 : Color.cyan(),
        4 : Color.blue(),
        5 : Color.magenta()
    ]
    
    var color: Color = Color.red() {
        didSet {
            saturationBrightnessTriangle.geometry.vertices[2].color = color
            saturationBrightnessTriangle.geometry.masterCompile()
            print(color)
        }
    }
    
    var touchInfo: [UITouch : Node] = [:]
    
    func present(in scene: Scene, from previousNode: Node, initialColor: Color?, onCompletion callback: @escaping (Color) -> ()) {
        // creating the hue rectangle
        let w = (scene.size.width - sqrt(3)*scene.size.height/2)/8
        let h = scene.size.height*3/4
        
        hueRectangle = Node()
        hueRectangle.size = Size(width: w, height: h)
        let ih = h/5
        for i in 0...4 {
            let a = Vertex(position: Vector3(-w/2, -h/2 + Float(i)*ih, 0), color: colors[i]!)
            let b = Vertex(position: Vector3(w/2, -h/2 + Float(i)*ih, 0), color: colors[i]!)
            let c = Vertex(position: Vector3(-w/2, -h/2 + Float(i+1)*ih, 0), color: colors[i+1]!)
            let d = Vertex(position: Vector3(w/2, -h/2 + Float(i+1)*ih, 0), color: colors[i+1]!)
            hueRectangle.geometry.vertices.append(contentsOf: [a, b, c, c, d, b])
        }
        hueRectangle.position = Point(x: -scene.size.width/2 + (scene.size.width - sqrt(3)*scene.size.height/2)/4, y: 0)
        self.addChild(hueRectangle)
        
        // creating the hue triangle
        saturationBrightnessTriangle = Node()
        saturationBrightnessTriangle.geometry.dynamic = true
        let a = Vertex(position: Vector3(-sqrt(3)*scene.size.height/4, -3*scene.size.height/8, 0), color: Color.black())
        let b = Vertex(position: Vector3(0, 3/4*scene.size.height/2, 0), color: Color.white())
        let c = Vertex(position: Vector3(sqrt(3)*scene.size.height/4, -3*scene.size.height/8, 0), color: Color.red())
        saturationBrightnessTriangle.geometry.vertices = [a, b, c]
        self.addChild(saturationBrightnessTriangle)
        
        if let color = initialColor {
            self.color = color
        }
        
        for child in scene.children {
            child.removeFromParent()
            containerNode.addChild(child)
        }
        scene.addChild(self)
        (scene as! LevelEditorScene).touchDelegates.append(self)
        //scene.view.currentDrawable!.texture.
        scene.compile()
        self.scene = scene
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var position = touch.location(in: scene.view).toPoint()
            position.y -= Float(scene.view.frame.height/2)
            position.y = -position.y
            position.x -= Float(scene.view.frame.width/2)
            if let node = self.nodes(at: position, relativeTo: .nodeSelf).first {
                touchInfo[touch] = node
            }
            
            if touchInfo[touch] === hueRectangle {
                pickColor(fromTouchPosition: position)
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touchInfo[touch] === hueRectangle {
                var position = touch.location(in: scene.view).toPoint()
                position.y -= Float(scene.view.frame.height/2)
                position.y = -position.y
                position.x -= Float(scene.view.frame.width/2)
                pickColor(fromTouchPosition: position)
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touchInfo[touch] === hueRectangle {
                var position = touch.location(in: scene.view).toPoint()
                position.y -= Float(scene.view.frame.height/2)
                position.y = -position.y
                position.x -= Float(scene.view.frame.width/2)
                pickColor(fromTouchPosition: position)
            }
            touchInfo.removeValue(forKey: touch)
        }
    }
    
    func pickColor(fromTouchPosition point: Point) {
        let h = scene.size.height
        var position = point
        position.y += h/2
        var i = floor((position.y - h/8)/(h/6))
        var p = ((position.y - h/8).truncatingRemainder(dividingBy: h/6))/(h/6)
        if (i < 0) {
            i = 0
            p = 0
        }
        if (i > 4) {
            i = 4
            p = 1
        }
        
        let a = colors[Int(i)]!
        let b = colors[Int(i+1)]!
        
        color = Color(r: p*(b.r - a.r) + a.r, g: p*(b.g - a.g) + a.g, b: p*(b.b - a.b) + a.b, a: 1)
    }
}
