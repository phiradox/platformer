//
//  GameScene.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 10/16/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import SpriteKit
import Metal
import MetalKit
import MetalPerformanceShaders

class GameScene: Scene {
    
    // MARK: Variables
    
    // starting with level 0
    var level: Int = 0 {
        didSet {
            updateLoops = []
            levelManager.loadLevel(level: level)
            appendMainUpdateLoop()
            update()
            update()
            compile()
        }
    }
    let UI = Node()
    
    var ambience: Ambience = Ambience()
    
    // save states
    let saveStateManager = SaveStateManager()
    
    var levelManager: LevelManager!
    
    // controls
    var input: (left: Bool, right: Bool, jump: Bool) = (false, false, false)
    var touchInfo: [UITouch: (left: Bool, right: Bool, jump: Bool)] = [:]
    var space: Button! = nil
    var leftFeedback: Node! = nil
    var rightFeedback: Node! = nil
    // buttons
    //var buttons: [SKNode: {()->()}] = [:]
    
    // MARK: Setup
    override func present() {
        super.present()
        sceneType = .game
        levelManager = LevelManager(parent: self)
        GlobalVars.blockTypes = BlockTypes(sized: GlobalVars.tileSize)
        GlobalVars.blockTypes.genBlocks()
        level = 0
        initUI()
        
        let path = Bundle.main.path(forResource: "Patakas World", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        gameViewController.play(sound: url, looped: -1)
    }
    
    func initUI() {
        self.addChild(UI)
        UI.zPosition = -10
        UI.position = Point(x: 0, y: 0)
        UI.geometry.node = UI
        UI.geometry.dynamic = true
        
        // jump button
        space = Button()
        space.label = "space"
        space.geometry.dynamic = true
        let spaceButtonClosure = { () -> () in
            self.input.jump = true
        }
        space.spawn(in: UI, at: Point(x: 0, y: self.size.height/10 - self.size.height/2), withSize: Size(width: self.size.width, height: self.size.height/5), onTouch: spaceButtonClosure)
        // jump button shading
        space.geometry.vertices[0].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom left
        space.geometry.vertices[1].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom right
        space.geometry.vertices[2].color = Color(r: 1, g: 1, b: 1, a: 0) // top left
        space.geometry.vertices[3].color = space.geometry.vertices[2].color // top left
        space.geometry.vertices[4].color = space.geometry.vertices[1].color // bottom right
        space.geometry.vertices[5].color = Color(r: 1, g: 1, b: 1, a: 0) // top right
        // end jump button shading
        // feedback
        leftFeedback = Node()
        leftFeedback.geometry.dynamic = true
        leftFeedback.geometry.vertices = Rectangle(size: Size(width: self.size.width/4, height: self.size.height/5*4), color: Color(r: 1, g: 1, b: 1, a: 0)).toVertices()
        leftFeedback.position = Point(x: -self.size.width/8*3, y: self.size.height/2 - self.size.height/5*4/2)
        rightFeedback = Node()
        rightFeedback.geometry.dynamic = true
        rightFeedback.geometry.vertices = Rectangle(size: Size(width: self.size.width/4, height: self.size.height/5*4), color: Color(r: 1, g: 1, b: 1, a: 0)).toVertices()
        rightFeedback.position = Point(x: self.size.width/8*3, y: self.size.height/2 - self.size.height/5*4/2)
        UI.addChild(leftFeedback)
        UI.addChild(rightFeedback)
        // end feedback
        
        // main menu button
        let menuButtonShape = ["XXXX", "X  X", "X  X", "XXXX"]
        let menuButton = Button();
        let block = Block()
        block.geometry.color = Color(r: 1.0, g: 0.0, b: 0.0, a: 0.5)
        block.size = Size(width: tileSize/2, height: tileSize/2)
        Rasterizer.rasterize(menuButtonShape, repeating: block, sized: tileSize/2, in: menuButton)
        
        let menuButtonClosure = { () -> () in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Menu View Controller") as! MenuViewController
            self.gameViewController.present(newViewController, animated: true, completion: nil)
        }
        menuButton.spawn(in: UI, at: Point(x: -self.size.width/2 + menuButton.size.width, y: self.size.height/2 - menuButton.size.height), withSize: menuButton.size, onTouch: menuButtonClosure)
        menuButton.geometry.vertices = []
    }
    
    // MARK: Update
    
    func appendMainUpdateLoop() {
        updateLoops.append({() -> (Bool) in
            self.levelManager.update(input: self.input)
            if self.levelManager.player.dead {
                self.levelManager.player.dead = false
                self.levelManager.restore(saveState: self.saveStateManager)
                self.compile()
            }
            self.ambience.position.y += 0.1
            //self.levelManager.world.scale.x*=1.01
            //self.levelManager.world.scale.y*=1.01
            //self.levelManager.world.isDirty = true
            return false
        })
    }
    
    // MARK: Render

    var plainRenderPipelineState: MTLRenderPipelineState! = nil
    var shadowRenderPipelineState: MTLRenderPipelineState! = nil
    var bgDistortionPipelineState: MTLRenderPipelineState! = nil
    //var spotlightRenderPipelineState: MTLRenderPipelineState! = nil
    //var backgroundLightRenderPipelineState: MTLRenderPipelineState! = nil
    var ambienceRenderPipelineState: MTLRenderPipelineState! = nil
    var multiplyComputePipelineState: MTLComputePipelineState! = nil
    var addComputePipelineState: MTLComputePipelineState! = nil
    var mainRenderPassDescriptor: MTLRenderPassDescriptor! = nil
    var shadowTexture: MTLTexture! = nil
    var ambienceTexture: MTLTexture! = nil
    
    var counter: Float = 0.0
    var bgDistortionBuffer: MTLBuffer! = nil
    
    var shadowOffset: Vector2! = nil
    var secondaryOffset: Vector2 = Vector2(0, 0)
    var delta: Float = 0.5
    var shadowOffsetUniform: BufferManager! = nil
    var shadowColor: [Float] = [0.0, 0.0, 0.0, 0.5]
    var shadowColorBuffer: MTLBuffer! = nil
    //var shadowProjectionMatrix: [Float] = []
    //var lights: [Light] = []
    //var lightFloatBuffer: [Float] = []
    //var lightsBuffer: MTLBuffer! = nil
    //var lightOffset: MTLBuffer! = nil
    
    override func prepare() {
        // bg distortion
        bgDistortionBuffer = device.makeBuffer(length: 64, options: [])
        
        // shadows
        shadowOffset = Vector2(-GlobalVars.tileSize*1.5, -GlobalVars.tileSize*1.3)
        //shadowProjectionMatrix = gameViewController.projectionMatrix
        
        /*
        // lights
        lights.append(Light(position: Vector2(0, 0), color: Color(r: 0, g: 1, b: 0, a: 1), radius: 1000, softness: 500, strength: 1))
        lights.append(Light(position: Vector2(1000, 0), color: Color(r: 0, g: 1, b: 0, a: 1), radius: 1000, softness: 500, strength: 0.5))
        lights.append(Light(position: Vector2(0, 750), color: Color(r:  1, g: 0, b: 0, a: 1), radius: 1000, softness: 500, strength: 0.5))
        lights.append(Light(position: Vector2(1000, 1750), color: Color(r: 0, g: 1, b: 1, a: 1), radius: 1000, softness: 500, strength: 0.5))
        
        for light in lights {
            lightFloatBuffer.append(contentsOf: [light.position.x, light.position.y])
        }
        for light in lights {
            lightFloatBuffer.append(contentsOf: [light.color.r, light.color.g, light.color.b])
        }
        for light in lights {
            lightFloatBuffer.append(light.radius)
        }
        for light in lights {
            lightFloatBuffer.append(light.softness)
        }
        for light in lights {
            lightFloatBuffer.append(light.strength)
        }
        print(lightFloatBuffer)
        lightsBuffer = device.makeBuffer(bytes: lightFloatBuffer, length: lightFloatBuffer.count * 32, options: [])
        
        lightOffset = device.makeBuffer(bytes: [Float(0), Float(0)], length: 64, options: [])*/
        
        // shaders
        let defaultLibrary = device.makeDefaultLibrary()!
        // plain shaders
        let plainFragmentProgram = defaultLibrary.makeFunction(name: "passThroughFragment")!
        let plainVertexProgram = defaultLibrary.makeFunction(name: "passThroughVertex")!
        // shadow shaders
        let shadowVertexProgram = defaultLibrary.makeFunction(name: "offsetVertex")!
        let shadowFragmentProgram = defaultLibrary.makeFunction(name: "shadowFragment")!
        // bg distortion
        let bgDistortionVertexProgram = defaultLibrary.makeFunction(name: "bgDistortion")!
        // spotlight shader
        //let spotlightVertexProgram = defaultLibrary.makeFunction(name: "vignette")!
        // background light fragment shader
        //let backgroundLightFragmentProgram = defaultLibrary.makeFunction(name: "bgLightingFragment")!
        // ambience shaders
        let ambienceVertexProgram = defaultLibrary.makeFunction(name: "ambience")!
        let ambienceFragmentProgram = defaultLibrary.makeFunction(name: "ambienceFragment")!
        
        // =============== Main Render Pass ================
        let renderLayerTextureDescriptor = MTLTextureDescriptor()
        renderLayerTextureDescriptor.width = Int(view.drawableSize.width)
        renderLayerTextureDescriptor.height = Int(view.drawableSize.height)
        renderLayerTextureDescriptor.pixelFormat = .bgra8Unorm
        renderLayerTextureDescriptor.usage = .unknown
        
        shadowTexture = device.makeTexture(descriptor: renderLayerTextureDescriptor)
        shadowTexture.label = "Shadow render texture"
        ambienceTexture = device.makeTexture(descriptor: renderLayerTextureDescriptor)
        ambienceTexture.label = "Ambience render texture"
        
        mainRenderPassDescriptor = MTLRenderPassDescriptor()
        
        mainRenderPassDescriptor.colorAttachments[0].texture = view.currentDrawable!.texture
        mainRenderPassDescriptor.colorAttachments[0].loadAction = .load
        mainRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainRenderPassDescriptor.colorAttachments[0].storeAction = .store
        
        mainRenderPassDescriptor.colorAttachments[1].texture = shadowTexture
        mainRenderPassDescriptor.colorAttachments[1].loadAction = .clear
        mainRenderPassDescriptor.colorAttachments[1].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainRenderPassDescriptor.colorAttachments[1].storeAction = .store
        
        mainRenderPassDescriptor.colorAttachments[2].texture = ambienceTexture
        mainRenderPassDescriptor.colorAttachments[2].loadAction = .clear
        mainRenderPassDescriptor.colorAttachments[2].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        mainRenderPassDescriptor.colorAttachments[2].storeAction = .store
        
        
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
        
        // pipeline configuration
        // =============== Plain Pipeline ================
        let plainRenderPipeline = MTLRenderPipelineDescriptor()
        plainRenderPipeline.label = "Simple Poly Render with Alpha"
        plainRenderPipeline.vertexFunction = plainVertexProgram
        plainRenderPipeline.fragmentFunction = plainFragmentProgram
        plainRenderPipeline.sampleCount = view.sampleCount
        
        plainRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        plainRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        plainRenderPipeline.colorAttachments[2] = colorAttachmentDescriptor
        
        // ================ Shadow Pipeline =================
        let shadowRenderPipeline = MTLRenderPipelineDescriptor()
        shadowRenderPipeline.label = "Generates Shadow Texture"
        shadowRenderPipeline.vertexFunction = shadowVertexProgram
        shadowRenderPipeline.fragmentFunction = shadowFragmentProgram
        shadowRenderPipeline.sampleCount = view.sampleCount
        
        shadowRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        shadowRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        shadowRenderPipeline.colorAttachments[2] = colorAttachmentDescriptor
        
        // ================ BG Distortion Pipeline ===========
        let bgDistortionPipeline = MTLRenderPipelineDescriptor()
        bgDistortionPipeline.label = "BG Distorter"
        bgDistortionPipeline.vertexFunction = bgDistortionVertexProgram
        bgDistortionPipeline.fragmentFunction = plainFragmentProgram
        bgDistortionPipeline.sampleCount = view.sampleCount
        
        bgDistortionPipeline.colorAttachments[0] = colorAttachmentDescriptor
        bgDistortionPipeline.colorAttachments[1] = colorAttachmentDescriptor
        bgDistortionPipeline.colorAttachments[2] = colorAttachmentDescriptor
        
        /* ================ Spotlight Pipeline ===============
        let spotlightRenderPipeline = MTLRenderPipelineDescriptor()
        spotlightRenderPipeline.label = "Spotlight Renderer"
        spotlightRenderPipeline.vertexFunction = spotlightVertexProgram
        spotlightRenderPipeline.fragmentFunction = plainFragmentProgram
        spotlightRenderPipeline.sampleCount = view.sampleCount
        
        spotlightRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        spotlightRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        spotlightRenderPipeline.colorAttachments[2] = colorAttachmentDescriptor
        */
        
        /* ================ Background Light Pipeline ========
        let backgroundLightRenderPipeline = MTLRenderPipelineDescriptor()
        backgroundLightRenderPipeline.label = "Background Renderer"
        backgroundLightRenderPipeline.vertexFunction = plainVertexProgram
        backgroundLightRenderPipeline.fragmentFunction = backgroundLightFragmentProgram
        backgroundLightRenderPipeline.sampleCount = view.sampleCount
        
        backgroundLightRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        backgroundLightRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        backgroundLightRenderPipeline.colorAttachments[2] = colorAttachmentDescriptor
        */
        
        // ================ Ambience Pipeline ================
        let ambienceRenderPipeline = MTLRenderPipelineDescriptor()
        ambienceRenderPipeline.label = "Ambience"
        ambienceRenderPipeline.vertexFunction = ambienceVertexProgram
        ambienceRenderPipeline.fragmentFunction = ambienceFragmentProgram
        ambienceRenderPipeline.sampleCount = view.sampleCount
        
        ambienceRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        ambienceRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        ambienceRenderPipeline.colorAttachments[2] = colorAttachmentDescriptor
        
        // the buffers to hold the colors and offset of the shadow
        shadowColorBuffer = device.makeBuffer(bytes: shadowColor, length: 32*4, options: [])
        shadowOffsetUniform = BufferManager(device: device, bufferCount: 3, bufferSize: 32*2)
        
        // =============== Compute Shaders ================
        let multiplyComputeProgram = defaultLibrary.makeFunction(name: "multiplyShader")!
        let addComputeProgram = defaultLibrary.makeFunction(name: "addShader")!
        
        //compile the pipelines
        do {
            try multiplyComputePipelineState =
                device.makeComputePipelineState(function: multiplyComputeProgram)
            try addComputePipelineState =
                device.makeComputePipelineState(function: addComputeProgram)
            try plainRenderPipelineState = device.makeRenderPipelineState(descriptor: plainRenderPipeline)
            try shadowRenderPipelineState = device.makeRenderPipelineState(descriptor: shadowRenderPipeline)
            try bgDistortionPipelineState = device.makeRenderPipelineState(descriptor: bgDistortionPipeline)
            //try spotlightRenderPipelineState = device.makeRenderPipelineState(descriptor: spotlightRenderPipeline)
            //try backgroundLightRenderPipelineState = device.makeRenderPipelineState(descriptor: backgroundLightRenderPipeline)
            try ambienceRenderPipelineState = device.makeRenderPipelineState(descriptor: ambienceRenderPipeline)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
    }
    
    func prepareAmbience(colored color: Color) {
        ambience.instances = []
        ambience.generateParticles(numbered: Int(Options.ambienceParticleCount.pointee), from: Vector2(-self.size.width*2, -self.size.height*2), to: Vector2(self.size.width*2, self.size.height*2), from: Vector2(1, 1), to: Vector2(30, 30), from: Color(r: color.r, g: color.g, b: color.b, a: color.a), to: Color(r: color.r, g: color.g, b: color.b, a: color.a))
        ambience.geometry.vertices = Rectangle(size: Size(width: tileSize/4, height: tileSize/4), color: Color(r: 1, g: 1, b: 1, a: 0.5)).toIndexedVertices()
        ambience.geometry.node = ambience
        ambience.geometry.masterCompile()
        ambience.compileBuffer(with: device)
        ambience.position.y = 0
    }
    
    override func render(with renderer: Renderer, and commandQueue: MTLCommandQueue) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.label = "Frame command buffer"
        if let currentDrawable = view.currentDrawable {
            mainRenderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture
            // drawing the background
            renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor!, and: bgDistortionPipelineState)
            counter += 0.02
            memcpy(bgDistortionBuffer.contents(), [counter, tileSize/self.size.width], 64)
            renderer.encoder.setVertexBuffer(bgDistortionBuffer, offset: 0, index: 2)
            //memcpy(lightOffset.contents(), [-levelManager.world.position.x, levelManager.world.position.y], 64)
            //renderer.encoder.setFragmentBuffer(lightsBuffer, offset: 0, index: 0)
           // renderer.encoder.setFragmentBuffer(lightOffset, offset: 0, index: 1)
            renderer.renderMaster(self, withChildren: false)
            
            if Options.shadowsBool.pointee {
                //renderer.projectionMatrix = shadowProjectionMatrix
                // rendering the shadow texture
                if secondaryOffset.x < levelManager.player.velocity.x - delta/2 {
                    secondaryOffset.x += delta
                }
                if secondaryOffset.x > levelManager.player.velocity.x + delta/2 {
                    secondaryOffset.x -= delta
                }
                if secondaryOffset.y < levelManager.player.velocity.y - delta/2 {
                    secondaryOffset.y += delta
                }
                if secondaryOffset.y > levelManager.player.velocity.y + delta/2 {
                    secondaryOffset.y -= delta
                }
                
                renderer.encoder.setRenderPipelineState(shadowRenderPipelineState)
                renderer.encoder.setVertexBuffer(shadowOffsetUniform.nextUniformsBuffer(ofData: [shadowOffset.x - secondaryOffset.x, shadowOffset.y - secondaryOffset.y]), offset: 0, index: 2)
                renderer.encoder.setFragmentBuffer(shadowColorBuffer, offset: 0, index: 0)
                renderer.renderMaster(levelManager.world, withChildren: true)
                renderer.encoder.endEncoding()
                
                var shadowBlurredTexture: MTLTexture! = nil
                if Options.shadowBlurBool.pointee {
                    let kernel = MPSImageGaussianBlur(device: device, sigma: Options.shadowBlurIntensity.pointee)
                    shadowBlurredTexture = shadowTexture
                    kernel.encode(commandBuffer: commandBuffer!, inPlaceTexture: &shadowBlurredTexture!, fallbackCopyAllocator: nil)
                }
                
                let compute = commandBuffer?.makeComputeCommandEncoder()
                compute?.setComputePipelineState(multiplyComputePipelineState)
                // input one -- primary texture
                compute?.setTexture(currentDrawable.texture, index: 0)
                // input two -- shadow texture
                compute?.setTexture(Options.shadowBlurBool.pointee ? shadowBlurredTexture : shadowTexture, index: 1)
                // output texture
                compute?.setTexture(currentDrawable.texture, index: 2)
                
                let textureWidth = Int(shadowTexture.width)
                let textureHeight = Int(shadowTexture.height)
                
                // set up an 8x8 group of threads
                let threadGroupSize = MTLSize(width: 8, height: 8, depth: 1)
                
                // define the number of such groups needed to process the textures
                let numGroups = MTLSize(
                    width: textureWidth/threadGroupSize.width+1,
                    height: textureHeight/threadGroupSize.height+1,
                    depth: 1)
                
                compute?.dispatchThreadgroups(numGroups,
                                             threadsPerThreadgroup: threadGroupSize)
                compute?.endEncoding()
                renderer.projectionMatrix = gameViewController.projectionMatrix
                renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor, and: plainRenderPipelineState)
            }
            
            // rendering the main scene
            //renderer.encoder.setFragmentBuffer(lightsBuffer, offset: 0, index: 0)
            //renderer.encoder.setFragmentBuffer(lightOffset, offset: 0, index: 1)
            renderer.renderMaster(levelManager.world, withChildren: true)
            
            if Options.ambienceBool.pointee {
                // rendering the ambience
                ambience.calculateScreenMatrix()
                renderer.encoder.setRenderPipelineState(ambienceRenderPipelineState)
                renderer.encoder.setVertexBuffer(ambience.geometry.masterBuffer!, offset: 0, index: 0)
                renderer.encoder.setVertexBuffer(renderer.transformationMatricesBuffers.nextUniformsBuffer(of: renderer.projectionMatrix, and: levelManager.world.transformationToScreen.toArray(), and: ambience.transformation.toArray()), offset: 0, index: 1)
                renderer.encoder.setVertexBuffer(ambience.instancesBuffer, offset: 0, index: 2)
                renderer.encoder.drawIndexedPrimitives(type: .triangle, indexCount: ambience.indexCount, indexType: ambience.indexType, indexBuffer: ambience.indexBuffer, indexBufferOffset: 0, instanceCount: ambience.instances.count)
                renderer.endEncoding(with: device)
                
                var ambienceBlurredTexture: MTLTexture! = nil
                if Options.ambienceBlurBool.pointee {
                    ambienceBlurredTexture = ambienceTexture
                    let kernel = MPSImageGaussianBlur(device: device, sigma: Options.ambienceBlurIntensity.pointee)
                    kernel.encode(commandBuffer: commandBuffer!, inPlaceTexture: &ambienceTexture!, fallbackCopyAllocator: nil)
                }
                
                let compute = commandBuffer?.makeComputeCommandEncoder()
                compute?.setComputePipelineState(addComputePipelineState)
                // input one -- primary texture
                compute?.setTexture(currentDrawable.texture, index: 0)
                // input two -- shadow texture
                compute?.setTexture(Options.ambienceBlurBool.pointee ? ambienceBlurredTexture : ambienceTexture, index: 1)
                // output texture
                compute?.setTexture(currentDrawable.texture, index: 2)
                
                let textureWidth = Int(ambienceTexture.width)
                let textureHeight = Int(ambienceTexture.height)
                
                // set up an 8x8 group of threads
                let threadGroupSize = MTLSize(width: 8, height: 8, depth: 1)
                
                // define the number of such groups needed to process the textures
                let numGroups = MTLSize(
                    width: textureWidth/threadGroupSize.width+1,
                    height: textureHeight/threadGroupSize.height+1,
                    depth: 1)
                
                compute?.dispatchThreadgroups(numGroups,
                                             threadsPerThreadgroup: threadGroupSize)
                compute?.endEncoding()
                renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor, and: plainRenderPipelineState)
            } else {
                renderer.endEncoding(with: device)
                renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor, and: plainRenderPipelineState)
            }
            
            renderer.renderMaster(UI, withChildren: true)
            renderer.endEncoding(with: device)
            
            commandBuffer?.present(currentDrawable)
        }
        
        commandBuffer?.commit()
    }
    
    // MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // record the precedence of the touch
            // self.touchInfo[touch] = self.touchInfo.count
            
            var position = touch.location(in: view).toPoint()
            position.y -= Float(view.frame.height/2)
            position.y = -position.y
            position.x -= Float(view.frame.width/2)
            
            if let button = UI.nodes(at: position, relativeTo: .screen).first as? Button {
                button.touched()
                if button.label == "space" {
                    space.geometry.vertices[0].color = Color(r: 1, g: 1, b: 1, a: 0.5) // bottom left
                    space.geometry.vertices[1].color = Color(r: 1, g: 1, b: 1, a: 0.5) // bottom right
                    space.geometry.vertices[2].color = Color(r: 1, g: 1, b: 1, a: 0.1) // top left
                    space.geometry.vertices[3].color = space.geometry.vertices[2].color // top left
                    space.geometry.vertices[4].color = space.geometry.vertices[1].color // bottom right
                    space.geometry.vertices[5].color = Color(r: 1, g: 1, b: 1, a: 0.1) // top right
                    space.geometry.masterCompile()
                    touchInfo[touch] = (false, false, true)
                }
            } else {
                // figure out which side of the screen the touch is on
                if position.x < 0 {
                    // touch was on left side
                    input.left = true
                    touchInfo[touch] = (true, false, false)
                    // left touch feedback
                    leftFeedback.geometry.vertices[0].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom left
                    leftFeedback.geometry.vertices[2].color = Color(r: 1, g: 1, b: 1, a: 0.3) // top left
                    leftFeedback.geometry.vertices[3].color = leftFeedback.geometry.vertices[2].color // top left
                    leftFeedback.geometry.masterCompile()
                } else {
                    // touch was on right side
                    input.right = true
                    touchInfo[touch] = (false, true, false)
                    // right touch feedback
                    rightFeedback.geometry.vertices[1].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom right
                    rightFeedback.geometry.vertices[4].color = rightFeedback.geometry.vertices[1].color // bottom right
                    rightFeedback.geometry.vertices[5].color = Color(r: 1, g: 1, b: 1, a: 0.3) // top right
                    rightFeedback.geometry.masterCompile()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // doesn't matter atm
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let info = touchInfo[touch] {
                if info.jump {
                    space.geometry.vertices[0].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom left
                    space.geometry.vertices[1].color = Color(r: 1, g: 1, b: 1, a: 0.3) // bottom right
                    space.geometry.vertices[2].color = Color(r: 1, g: 1, b: 1, a: 0) // top left
                    space.geometry.vertices[3].color = space.geometry.vertices[2].color // top left
                    space.geometry.vertices[4].color = space.geometry.vertices[1].color // bottom right
                    space.geometry.vertices[5].color = Color(r: 1, g: 1, b: 1, a: 0) // top right
                    space.geometry.masterCompile()
                    input.jump = false
                }
                if info.left {
                    input.left = false
                    // left touch feedback
                    leftFeedback.geometry.vertices[0].color = Color(r: 1, g: 1, b: 1, a: 0) // bottom left
                    leftFeedback.geometry.vertices[2].color = Color(r: 1, g: 1, b: 1, a: 0) // top left
                    leftFeedback.geometry.vertices[3].color = leftFeedback.geometry.vertices[2].color // top left
                    leftFeedback.geometry.masterCompile()
                }
                if info.right {
                    input.right = false
                    // right touch feedback
                    rightFeedback.geometry.vertices[1].color = Color(r: 1, g: 1, b: 1, a: 0) // bottom right
                    rightFeedback.geometry.vertices[4].color = rightFeedback.geometry.vertices[1].color // bottom right
                    rightFeedback.geometry.vertices[5].color = Color(r: 1, g: 1, b: 1, a: 0) // top right
                    rightFeedback.geometry.masterCompile()
                }
                touchInfo.removeValue(forKey: touch)
            }
        }
    }
    
    func generateBackground(topLeft color1: Color, topRight color2: Color, bottomLeft color3: Color, bottomRight color4: Color) {
        var gridSize = Size(width: size.width/tileSize + 2, height: size.height/tileSize + 3)
        var vertices: [[Vertex]] = Array(repeating: Array(repeating: Vertex(position: Vector3(x: 0, y: 0, z: 0), color: Color(r: 0, g: 0, b: 0, a: 0)), count: Int(gridSize.height)), count: Int(gridSize.width))
        gridSize.width = Float(vertices.count)
        gridSize.height = Float(vertices[0].count)
        for x in 0..<Int(gridSize.width) {
            for y in 0..<Int(gridSize.height) {
                let xRatio = Float(x)/gridSize.width
                let yRatio = Float(y)/gridSize.height
                var red = yRatio*(xRatio*color1.r + (1-xRatio)*color2.r) + (1-yRatio)*(xRatio*color3.r + (1-xRatio)*color4.r)
                var green = yRatio*(xRatio*color1.g + (1-xRatio)*color2.g) + (1-yRatio)*(xRatio*color3.g + (1-xRatio)*color4.g)
                var blue = yRatio*(xRatio*color1.b + (1-xRatio)*color2.b) + (1-yRatio)*(xRatio*color3.b + (1-xRatio)*color4.b)
                let coefficient = 1 + Float(arc4random()) / Float(UINT32_MAX)/3 - 0.163
                red *= coefficient
                green *= coefficient
                blue *= coefficient
                let baseColor = Color(r: red, g: green, b: blue, a: 1)
                vertices[x][y] = Vertex(position: Vector3(x: (Float(x)-gridSize.width/2)*tileSize, y: (Float(y)-gridSize.height/2)*tileSize, z: 0), color: baseColor)
            }
        }
        
        self.geometry.vertices = []
        
        for x in 0..<Int(gridSize.width) {
            for y in 0..<Int(gridSize.height) {
                if x >= 0 && x < Int(gridSize.width)-1 {
                    if y >= 0 && y < Int(gridSize.height)-1 {
                       self.geometry.vertices.append(contentsOf: [vertices[x][y], vertices[x+1][y], vertices[x][y+1]])
                    }
                }
                if x > 0 && x <= Int(gridSize.width)-1 {
                    if y > 0 && y <= Int(gridSize.height)-1 {
                        self.geometry.vertices.append(contentsOf: [vertices[x][y], vertices[x-1][y], vertices[x][y-1]])
                    }
                }
            }
        }
    }

}
