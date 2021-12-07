//
//  LevelEditor.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/16/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.

import Foundation
import SpriteKit
import UIKit

class LevelEditorScene: Scene {
    
    let UI: Node = Node()
    var selectedBlock: Block! = nil
    
    let levelNode: Node = Node()
    //var editorNodes: [EditorNode] = []
    
    var levelScrollView: SKScrollView! = nil
    
    var blockSelectionMenu: SKScrollView! = nil
    var blockButtons = Node()
    
    var blockTypes: BlockTypes! = nil
    
    static var levelBeingEditted: Int! = nil
    var level: Level! = nil
    
    override func present() {
        // initialize block selection menu
        super.present()
        sceneType = .levelEditor
        self.addChild(UI)
        print(self.sortZPosition)
        self.sortZPosition = true
        UI.zPosition = -10
        self.addChild(levelNode)
        
        UI.addChild(blockButtons)
        blockTypes = BlockTypes(sized: tileSize)
        blockTypes.genBlocks()
        
        initBlockSelectionMenu()
        view.addSubview(blockSelectionMenu)
        
        initLevelScrollView()
        view.addSubview(levelScrollView)
        
        if LevelEditorScene.levelBeingEditted < SaveData.levels.count {
            loadCurrentLevel()
            self.level = SaveData.levels[LevelEditorScene.levelBeingEditted]
        } else {
            // initialize the beginning node
            let editorNode = EditorNode()
            editorNode.spawn(in: levelNode, at: Point(x: self.size.width*5, y: -self.size.height*5), withSize: Size(width: tileSize * 2, height: tileSize * 2), onTouch: {() -> () in })
            //editorNodes.append(editorNode)
            self.level = Level(named: "Untitled", levelData: [""], ambience: Color(r: 1.0, g: 0.0, b: 0.0, a: 1.0), background: Color(r: 0.1, g: 0.0, b: 0.3, a: 1.0), mainBlockColor: Color(r: 0.7, g: 0.7, b: 0.7, a: 1.0), secondaryBlockColor: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
        }
        selectedBlock = blockTypes.blocks["X"]!.block.duplicate()
        initButtons()
        
        self.geometry.color = self.level.background
    }
    
    func initBlockSelectionMenu() {
        blockSelectionMenu = SKScrollView(in: self, of: blockButtons, frame: CGRect(x: 0, y: 0, width: CGFloat(tileSize * 4), height: CGFloat(self.size.height)), with: .vertical)
        // 1 added to count for custom generated "player" block seen below
        blockSelectionMenu.contentSize = CGSize(width: CGFloat(tileSize * 4), height: CGFloat(tileSize * 4 * Float(blockTypes.editorBlocks.count+1)))
        blockButtons.geometry.dynamic = true
        blockButtons.position.x = -self.size.width/2
        // creating a button with a display block for each block type
        for iterated: (offset: Int, element: (key: Character, value: (label: String, block: Block))) in blockTypes.editorBlocks.enumerated() {
            let button = Button()
            let action = {() -> () in
                self.selectedBlock = iterated.element.value.block
                self.selectedBlock.label = String(iterated.element.key)
            }
            button.spawn(in: blockButtons, at: Point(x: tileSize * 2, y: self.size.height/2-Float(iterated.offset) * tileSize * 4 - tileSize * 2), withSize: Size(width: tileSize * 4, height: tileSize * 4), onTouch: action)
            button.geometry.color = Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5)
            let block = iterated.element.value.block.duplicate()
            block.spawn(at: Point(x: 0, y: 0), in: button, size: Size(width: tileSize, height: tileSize))
            for (n, _) in block.geometry.vertices.enumerated() {
                block.geometry.vertices[n].position.x *= 2
                block.geometry.vertices[n].position.y *= 2
            }
            block.label = String(iterated.element.key)
        }
        // the "block" which will contain the player spawn char
        let button = Button()
        let block = Block()
        block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
        block.spawn(at: Point(x: 0, y: 0), in: button, size: Size(width: tileSize, height: tileSize * 2))
        block.label = String("@")
        let action = {() -> () in
            self.selectedBlock = block
            self.selectedBlock.label = String("@")
        }
        button.spawn(in: blockButtons, at: Point(x: tileSize * 2, y: self.size.height/2-Float(blockTypes.editorBlocks.count) * tileSize * 4 - tileSize * 2), withSize: Size(width: tileSize * 4, height: tileSize * 4), onTouch: action)
        button.geometry.color = Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5)
    }
    
    func initLevelScrollView() {
        levelScrollView = SKScrollView(in: self, of: levelNode, frame: CGRect(x: CGFloat(tileSize * 4), y: 0, width: CGFloat(self.size.width - tileSize * 4), height: CGFloat(self.size.height)), with: .both)
        levelScrollView.contentSize = CGSize(width: CGFloat(self.size.width * 10), height: CGFloat(self.size.height * 10))
        levelNode.geometry.dynamic = true
        levelScrollView.contentOffset = CGPoint(x: CGFloat(self.size.width*5), y: CGFloat(self.size.height*5))
    }
    
    func initButtons() {
        // main menu button
        let menuButtonShape = ["XXXX", "X  X", "X  X", "XXXX"]
        let menuButton = Button();
        var block = Block()
        block.geometry.color = Color(r: 1.0, g: 0.0, b: 0.0, a: 1)
        block.size = Size(width: tileSize/2, height: tileSize/2)
        Rasterizer.rasterize(menuButtonShape, repeating: block, sized: tileSize/2, in: menuButton)
        
        let menuButtonClosure = { () -> () in
            self.blockSelectionMenu.removeFromSuperview()
            self.levelScrollView.removeFromSuperview()
            self.gameViewController.present(MenuScene(of: self.size, and: self.tileSize, in: self.view, and: self.gameViewController, device: self.device))
        }
        menuButton.spawn(in: UI, at: Point(x: self.size.width/2 - menuButton.size.width, y: self.size.height/2 - menuButton.size.height), withSize: menuButton.size, onTouch: menuButtonClosure)
        menuButton.geometry.vertices = []
        menuButton.geometry.dynamic = true
        
        // play level button
        let playButtonShape = ["X    ", "XXX  ", "XXXXX", "XXX  ", "X    "]
        let playButton = Button();
        block = Block()
        block.geometry.color = Color(r: 0.0, g: 1.0, b: 0.0, a: 1)
        block.size = Size(width: tileSize/2, height: tileSize/2)
        Rasterizer.rasterize(playButtonShape, repeating: block, sized: tileSize/2, in: playButton)
        
        let playButtonClosure = { () -> () in
            self.gameViewController.present(GameScene(of: self.size, and: self.tileSize, in: self.view, and: self.gameViewController, device: self.device))
            (self.gameViewController.scene as! GameScene).levelManager.loadLevel(level: self.genLevel())
            self.gameViewController.scene.compile()
            self.blockSelectionMenu.removeFromSuperview()
            self.levelScrollView.removeFromSuperview()
        }
        playButton.spawn(in: UI, at: Point(x: self.size.width/2 - playButton.size.width, y: -self.size.height/2 + playButton.size.height), withSize: playButton.size, onTouch: playButtonClosure)
        playButton.geometry.vertices = []
        playButton.geometry.dynamic = true
        
        // save level button
        let saveShape = ["  X  ", "  X  ", "XXXXX", " XXX ", "  X  "]
        let saveButton = Button()
        block = Block()
        block.geometry.color = Color(r: 0.0, g: 0.0, b: 1.0, a: 1)
        block.size = Size(width: tileSize/2, height: tileSize/2)
        Rasterizer.rasterize(saveShape, repeating: block, sized: tileSize/2, in: saveButton)
        
        let saveButtonClosure = { () -> () in
            let node = Node()
            self.UI.addChild(node)
            Menus.prepare(.saveLevelMenu, in: node, in: self)
        }
        saveButton.spawn(in: UI, at: Point(x: self.size.width/2 - saveButton.size.width*2.5, y: -self.size.height/2 + saveButton.size.height), withSize: saveButton.size, onTouch: saveButtonClosure)
        saveButton.geometry.vertices = []
        saveButton.geometry.dynamic = true
        
        // level options button
        let optionsShape = ["XXX X",
                            "X  X ",
                            "X X X",
                            "X   X",
                            "XXXXX"]
        let optionsButton = Button()
        block = Block()
        block.geometry.color = Color(r: 1.0, g: 1.0, b: 0.0, a: 1)
        block.size = Size(width: tileSize/2, height: tileSize/2)
        Rasterizer.rasterize(optionsShape, repeating: block, sized: tileSize/2, in: optionsButton)
        
        let optionsButtonClosure = { () -> () in
            //let node = Node()
            //self.UI.addChild(node)
            //Menus.prepare(.levelOptionsMenu, in: node, in: self)
            let colorPicker = ColorPicker()
            colorPicker.present(in: self, from: self.UI, initialColor: nil, onCompletion: {(Color) -> () in })
            self.levelScrollView.isScrollEnabled = false
        }
        optionsButton.spawn(in: UI, at: Point(x: -self.size.width/2 + blockSelectionMenu.contentSize.toSize().width + optionsButton.size.width/2 + tileSize, y: -self.size.height/2 + optionsButton.size.height), withSize: saveButton.size, onTouch: optionsButtonClosure)
        optionsButton.geometry.vertices = []
        optionsButton.geometry.dynamic = true
    }
    
    func loadCurrentLevel() {
        let levelData = SaveData.levels[LevelEditorScene.levelBeingEditted].level!
        let levelSizeInEditor = Size(width: Float(levelData[0].count) * GlobalVars.tileSize*2, height: Float(levelData.count) * GlobalVars.tileSize*2)
        let offset = Point(x: self.size.width*5, y: -self.size.height*5)
        for (y, row) in levelData.reversed().enumerated() {
            for (x, char) in row.enumerated() {
                if char != " " {
                    let editorNode = EditorNode()
                    editorNode.spawn(in: levelNode, at: Point(x: Float(x)*tileSize*2 - levelSizeInEditor.width/2 + offset.x, y: Float(y)*tileSize*2 - levelSizeInEditor.height/2 + offset.y), withSize: Size(width: tileSize*2, height: tileSize*2), onTouch: {() -> () in })
                    editorNode.setBlock(to: char)
                }
            }
        }
    }
    
    func genLevel() -> [String] {
        if levelNode.children.count <= 1 {
            return [""]
        }
        var topLeft = Point(x: 2147483647, y: -2147483647)
        var bottomRight = Point(x: -2147483647, y: 2147483647)
        for node in self.levelNode.children {
            if let editorNode = node as? EditorNode {
                if !editorNode.empty {
                    if editorNode.position.x < topLeft.x {
                        topLeft.x = editorNode.position.x
                    }
                    if editorNode.position.y > topLeft.y {
                        topLeft.y = editorNode.position.y
                    }
                    if editorNode.position.x > bottomRight.x {
                        bottomRight.x = editorNode.position.x
                    }
                    if editorNode.position.y < bottomRight.y {
                        bottomRight.y = editorNode.position.y
                    }
                }
            }
        }
        
        let minX = Int(topLeft.x / (tileSize*2))
        let maxY = Int(topLeft.y / (tileSize*2))
        let maxX = Int(bottomRight.x / (tileSize*2))
        let minY = Int(bottomRight.y / (tileSize*2))
        
        var newLevel: [String] = []
        for y in minY-1...maxY-1 {
            var row: String = ""
            for x in minX...maxX {
                let nodes = levelNode.nodes(at: Point(x: Float(x)*tileSize*2, y: Float(y)*tileSize*2), relativeTo: .nodeSelf)
                if let editorNode = nodes.first as? EditorNode {
                    if !editorNode.empty {
                        row.append(Character(editorNode.block!.label!))
                    } else {
                        row.append(" ")
                    }
                } else {
                    row.append(" ")
                }
            }
            newLevel.append(row)
        }
        newLevel.reverse()
        print(newLevel)
        return newLevel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for delegate in touchDelegates {
            delegate.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for delegate in touchDelegates {
            delegate.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchDelegates.isEmpty {
            for touch in touches {
                var position = touch.location(in: view).toPoint()
                position.y -= Float(view.frame.height/2)
                position.y = -position.y
                position.x -= Float(view.frame.width/2)
                let nodes = UI.nodes(at: position, relativeTo: .screen)
                if !nodes.isEmpty {
                    for node in nodes {
                        if let pressable = node as? Pressable {
                            pressable.touched()
                            continue
                        }
                    }
                } else if let node = self.nodes(at: position, relativeTo: .screen).first {
                    if let pressable = node as? Pressable {
                        pressable.touched()
                    }
                }
            }
        } else {
            for delegate in touchDelegates {
                delegate.touchesEnded(touches, with: event)
            }
        }
    }
    
    // MARK: Rendering
    
    var plainRenderPipelineState: MTLRenderPipelineState! = nil
    var mainRenderPassDescriptor: MTLRenderPassDescriptor! = nil
    
    override func render(with renderer: Renderer, and commandQueue: MTLCommandQueue) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.label = "Frame command buffer"
        if let currentDrawable = view.currentDrawable {
            mainRenderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture
            //drawing the whole scene
            renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor, and: plainRenderPipelineState)
            renderer.renderMaster(self, withChildren: true)
            renderer.endEncoding(with: device)
            commandBuffer?.present(currentDrawable)
        }
        commandBuffer?.commit()
    }
    
    override func prepare() {
        // shaders
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "passThroughFragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "passThroughVertex")
        
        // ===== Main Render Pass =====
        mainRenderPassDescriptor = MTLRenderPassDescriptor()
        mainRenderPassDescriptor.colorAttachments[0].texture = view.currentDrawable!.texture
        mainRenderPassDescriptor.colorAttachments[0].loadAction = .clear
        mainRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainRenderPassDescriptor.colorAttachments[0].storeAction = .store
        
        // basic, reused color attachment descriptor with alpha capabilities
        let colorAttachmentDescriptor = MTLRenderPipelineColorAttachmentDescriptor()
        colorAttachmentDescriptor.isBlendingEnabled = true
        colorAttachmentDescriptor.rgbBlendOperation = .add
        colorAttachmentDescriptor.alphaBlendOperation = .add
        colorAttachmentDescriptor.sourceRGBBlendFactor = .sourceAlpha
        colorAttachmentDescriptor.sourceAlphaBlendFactor = .sourceAlpha
        colorAttachmentDescriptor.destinationRGBBlendFactor = .oneMinusSourceAlpha
        colorAttachmentDescriptor.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        colorAttachmentDescriptor.pixelFormat = MTLPixelFormat(rawValue: view.colorPixelFormat.rawValue)!
        
        // pipeline confiugration
        // ===== Plain Pipeline =====
        let plainRenderPipeline = MTLRenderPipelineDescriptor()
        plainRenderPipeline.label = "Simple Poly Render with Alpha"
        plainRenderPipeline.vertexFunction = vertexProgram
        plainRenderPipeline.fragmentFunction = fragmentProgram
        plainRenderPipeline.sampleCount = view.sampleCount
        
        plainRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        
        //compile the pipeline
        do {
            try plainRenderPipelineState = device.makeRenderPipelineState(descriptor: plainRenderPipeline)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
    }
    
}
