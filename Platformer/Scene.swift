//
//  Scene.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/25/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit
import Metal
import MetalKit

class Scene: Node {
    
    enum SceneType {
        case mainMenu
        case game
        case levelEditor
    }
    
    var view: MTKView
    var device: MTLDevice! = nil
    var gameViewController: GameViewController! = nil
    var tileSize: Float
    var sceneType: SceneType! = nil
    
    var updateLoops: [() -> (Bool)] = []
    var touchDelegates: [TouchDelegate] = []
    
    init(of size: Size, and tileSize: Float, in view: MTKView, and gameViewController: GameViewController?, device: MTLDevice) {
        self.view = view
        self.tileSize = tileSize
        super.init() // Node()
        self.size = size
        self.device = device
        self.gameViewController = gameViewController
        self.geometry.dynamic = true
        self.geometry.vertices = Rectangle(size: size, color: Color(r: 0, g: 0, b: 0, a: 1)).toVertices()
    }
    
    func present() {
        geometry.node = self
    }
    
    func update() {
        var indicesToRemove: [Int] = []
        for (n, loop) in updateLoops.enumerated() {
            if loop() {
                indicesToRemove.append(n)
            }
        }
        
        for i in indicesToRemove.reversed() {
            let _ = updateLoops.remove(at: i)
        }
    }
    
    func render(with renderer: Renderer, and commandQueue: MTLCommandQueue) {
        
    }
    
    func prepare() {
        
    }
    
    func compile() {
        geometry.masterCompile()
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func setColor(_ color1: Color, _ color2: Color, _ color3: Color, _ color4: Color) {
        geometry.vertices[0].color = color1 // bottom left
        geometry.vertices[1].color = color2 // bottom right
        geometry.vertices[2].color = color3 // top left
        geometry.vertices[3].color = geometry.vertices[2].color // top left
        geometry.vertices[4].color = geometry.vertices[1].color // bottom right
        geometry.vertices[5].color = color4 // top right
    }
    
}
