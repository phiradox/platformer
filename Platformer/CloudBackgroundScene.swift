//
//  CloudBackgroundScene.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/25/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

import Metal
import MetalPerformanceShaders

class CloudBackgroundScene: Scene {
        
    let cloudsPerSecond = 1.0
    var clouds: [(Node, Float)] = []
    var cloudContainer: Node = Node()
    
    var backgroundColorCycle: [[Color]] = [
        [
            Color(r: 0.1, g: 0.0, b: 0.3, a: 1.0),
            Color(r: 0.0, g: 0.0, b: 0.4, a: 1.0),
            Color(r: 0.05, g: 0.0, b: 0.1, a: 1.0),
            Color(r: 0.1, g: 0.0, b: 0.2, a: 1.0)
        ],
        [
            
            Color(r: 0.992, g: 0.659, b: 0.482, a: 1),
            Color(r: 0.427, g: 0.604, b: 0.769, a: 1),
            Color(r: 0.522, g: 0.278, b: 0.302, a: 1),
            Color(r: 0.129, g: 0.259, b: 0.400, a: 1),
        ],
        [
            Color(r: 0.992, g: 0.859, b: 0.698, a: 1),
            Color(r: 0.996, g: 1.000, b: 0.949, a: 1),
            Color(r: 0.071, g: 0.447, b: 0.804, a: 1),
            Color(r: 0.184, g: 0.557, b: 0.808, a: 1)
        ],
        [
            Color(r: 0.490, g: 0.761, b: 0.984, a: 1),
            Color(r: 0.400, g: 0.737, b: 0.988, a: 1),
            Color(r: 0.016, g: 0.165, b: 0.667, a: 1),
            Color(r: 0.016, g: 0.161, b: 0.647, a: 1)
        ],
        [
            Color(r: 0.812, g: 0.435, b: 0.275, a: 1),
            Color(r: 1, g: 1, b: 0.655, a: 1),
            Color(r: 0.227, g: 0.182, b: 0.300, a: 1),
            Color(r: 0.043, g: 0.145, b: 0.310, a: 1)
        ]
    ]
    var backgroundColorIndex: Int = 0
    var backgroundColorCounters: (counter: Int, r: [Float], g: [Float], b: [Float]) = (0, [], [], [])
    var backgroundColorCycleSegmentLength = 150
    
    let cloudShapes: [[String]] = [
        [
            "     99  ",
            "   76789 ",
            "975466889"
        ],
        [
            "       999     ",
            " 99876778899    ",
            "      56788899  ",
            "        678899  ",
            "         667    ",
            "      44556699  ",
            "2222333445567899",
            "     333344567   "
        ],
        [
            "      99  ",
            "     7889 ",
            "   7656789",
            "8765446789",
            "    4445  "
        ],
        [
            "   99999  9999   ",
            "876656789656789  ",
            "  994578956789   ",
            "878   478996789  ",
            "   3456788899979 ",
            "23333445567888999"
        ],
        [
            "                  99      ",
            "   999   99999998767999   ",
            "987  79876  55677  5678999"
        ]
    ]
    
    override func present() {
        super.present()
        sceneType = .mainMenu
        
        self.addChild(cloudContainer)
        cloudContainer.geometry.dynamic = true
        cloudContainer.sortZPosition = false
        
        self.setColor(backgroundColorCycle[0][0], backgroundColorCycle[0][1], backgroundColorCycle[0][2], backgroundColorCycle[0][3])
        self.backgroundColorCounters.counter = self.backgroundColorCycleSegmentLength
        
        let dynamicBGLoop = {() -> (Bool) in
            if self.sceneType == .mainMenu {
                self.backgroundColorCounters.counter += 1
                if self.backgroundColorCounters.counter >= self.backgroundColorCycleSegmentLength {
                    self.backgroundColorCounters.counter = 0
                    self.setColor(self.backgroundColorCycle[self.backgroundColorIndex][0], self.backgroundColorCycle[self.backgroundColorIndex][1], self.backgroundColorCycle[self.backgroundColorIndex][2], self.backgroundColorCycle[self.backgroundColorIndex][3])
                    
                    // tick color index
                    let oldIndex = self.backgroundColorIndex
                    self.backgroundColorIndex += 1
                    if self.backgroundColorIndex >= self.backgroundColorCycle.count {
                        self.backgroundColorIndex = 0
                    }
                    
                    self.backgroundColorCounters.r = []
                    self.backgroundColorCounters.g = []
                    self.backgroundColorCounters.b = []
                    for i in 0...3 {
                        self.backgroundColorCounters.r.append((self.backgroundColorCycle[oldIndex][i].r - self.backgroundColorCycle[self.backgroundColorIndex][i].r)/Float(self.backgroundColorCycleSegmentLength))
                        self.backgroundColorCounters.g.append((self.backgroundColorCycle[oldIndex][i].g - self.backgroundColorCycle[self.backgroundColorIndex][i].g)/Float(self.backgroundColorCycleSegmentLength))
                        self.backgroundColorCounters.b.append((self.backgroundColorCycle[oldIndex][i].b - self.backgroundColorCycle[self.backgroundColorIndex][i].b)/Float(self.backgroundColorCycleSegmentLength))
                    }
                }
                let array = [0, 1, 2, 5]
                for (n, i) in array.enumerated() {
                    self.geometry.vertices[i].color.r -= self.backgroundColorCounters.r[n]
                    self.geometry.vertices[i].color.g -= self.backgroundColorCounters.g[n]
                    self.geometry.vertices[i].color.b -= self.backgroundColorCounters.b[n]
                }
                self.geometry.vertices[3].color = self.geometry.vertices[2].color // top left
                self.geometry.vertices[4].color = self.geometry.vertices[1].color // bottom right
                self.geometry.compileSelf()
                self.geometry.isDirty = false
                return false
            } else {
                return true
            }
        }
        
        updateLoops.append(dynamicBGLoop)
    }
    
    // MARK: Update
    
    override func update() {
        super.update()
        if Options.cloudsBool.pointee {
            if arc4random_uniform(UInt32(60.0 * 1/cloudsPerSecond)) == 1 {
                let cloud = Node()
                cloud.geometry.dynamic = true
                Rasterizer.rasterizeWithGradient(cloudShapes[Int(arc4random_uniform(UInt32(cloudShapes.count)))], from: Color(r: 0.3, g: 0.1, b: 0.3, a: 0.3), to: Color(r: 1.0, g: 1.0, b: 1.0, a: 0.7), sized: tileSize, in: cloud)
                cloud.position = Point(x: self.size.width/2, y: self.size.height/2 - Float(arc4random_uniform(UInt32(self.size.height))))
                
                cloudContainer.addChild(cloud)
                let velocity = (-Float(Double(arc4random_uniform(UInt32(5)))/2.5) - 1.0)*8
                //cloud.parallax = -velocity + 1.0
                clouds.append((cloud, velocity))
            }
            
            for (node, velocity) in clouds {
                node.position.x += velocity
                if node.position.x < -self.size.width {
                    node.removeFromParent()
                }
            }
        }
        
    }
    
    // MARK: Rendering
    
    var plainRenderPipelineState: MTLRenderPipelineState! = nil
    var mainRenderPassDescriptor: MTLRenderPassDescriptor! = nil
    var cloudBloomRenderPipelineState: MTLRenderPipelineState! = nil
    var cloudBloomRenderPassDescriptor: MTLRenderPassDescriptor! = nil
    var cloudBloomTexture: MTLTexture! = nil
    var addComputePipelineState: MTLComputePipelineState! = nil
    
    override func render(with renderer: Renderer, and commandQueue: MTLCommandQueue) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.label = "Frame command buffer"
        if let currentDrawable = view.currentDrawable {
            mainRenderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture
            //drawing the scene background
            renderer.initEncoder(with: commandBuffer!, and: mainRenderPassDescriptor, and: plainRenderPipelineState)
            renderer.renderMaster(self, withChildren: false)
            
            // drawing the cloud bloom
            if Options.cloudsBool.pointee {
                renderer.encoder.setRenderPipelineState(cloudBloomRenderPipelineState)
                renderer.renderMaster(cloudContainer, withChildren: true)
                renderer.endEncoding(with: device)
                
                var cloudBloomBlurredTexture = cloudBloomTexture
                if Options.cloudBlurBool.pointee {
                    let kernel = MPSImageGaussianBlur(device: device, sigma: Options.cloudBlurIntensity.pointee)
                    kernel.encode(commandBuffer: commandBuffer!, inPlaceTexture: &cloudBloomBlurredTexture!, fallbackCopyAllocator: nil)
                }
                
                let compute = commandBuffer?.makeComputeCommandEncoder()
                compute?.setComputePipelineState(addComputePipelineState)
                // input one -- primary texture
                compute?.setTexture(currentDrawable.texture, index: 0)
                // input two -- shadow texture
                compute?.setTexture(cloudBloomBlurredTexture, index: 1)
                // output texture
                compute?.setTexture(currentDrawable.texture, index: 2)
                
                let textureWidth = Int(cloudBloomTexture.width)
                let textureHeight = Int(cloudBloomTexture.height)
                
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
            }
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
        let cloudBloomFragmentProgram = defaultLibrary.makeFunction(name: "cloudBloomFragment")!
        
        // ===== Main Render Pass =====
        mainRenderPassDescriptor = MTLRenderPassDescriptor()
        mainRenderPassDescriptor.colorAttachments[0].texture = view.currentDrawable!.texture
        mainRenderPassDescriptor.colorAttachments[0].loadAction = .load
        mainRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainRenderPassDescriptor.colorAttachments[0].storeAction = .store
        
        // Cloud Bloom
        let renderLayerTextureDescriptor = MTLTextureDescriptor()
        renderLayerTextureDescriptor.width = Int(view.drawableSize.width)
        renderLayerTextureDescriptor.height = Int(view.drawableSize.height)
        renderLayerTextureDescriptor.pixelFormat = .bgra8Unorm
        renderLayerTextureDescriptor.usage = .unknown
        cloudBloomTexture = device.makeTexture(descriptor: renderLayerTextureDescriptor)
        cloudBloomTexture.label = "Cloud bloom render texture"
        
        mainRenderPassDescriptor.colorAttachments[1].texture = cloudBloomTexture
        mainRenderPassDescriptor.colorAttachments[1].loadAction = .clear
        mainRenderPassDescriptor.colorAttachments[1].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        mainRenderPassDescriptor.colorAttachments[1].storeAction = .store
        
        // Basic, reused color attachment descriptor with alpha capabilities
        let colorAttachmentDescriptor = MTLRenderPipelineColorAttachmentDescriptor()
        colorAttachmentDescriptor.isBlendingEnabled = true
        colorAttachmentDescriptor.rgbBlendOperation = .add
        colorAttachmentDescriptor.alphaBlendOperation = .add
        colorAttachmentDescriptor.sourceRGBBlendFactor = .sourceAlpha
        colorAttachmentDescriptor.sourceAlphaBlendFactor = .sourceAlpha
        colorAttachmentDescriptor.destinationRGBBlendFactor = .oneMinusSourceAlpha
        colorAttachmentDescriptor.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        colorAttachmentDescriptor.pixelFormat = MTLPixelFormat(rawValue: view.colorPixelFormat.rawValue)!
        
        // Pipeline Confiugrations
        // ===== Plain Pipeline =====
        let plainRenderPipeline = MTLRenderPipelineDescriptor()
        plainRenderPipeline.label = "Simple Poly Render with Alpha"
        plainRenderPipeline.vertexFunction = vertexProgram
        plainRenderPipeline.fragmentFunction = fragmentProgram
        plainRenderPipeline.sampleCount = view.sampleCount
        
        plainRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        plainRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        
        // ===== Bloom Pipeline ======
        let cloudBloomRenderPipeline = MTLRenderPipelineDescriptor()
        cloudBloomRenderPipeline.label = "Generates Cloud Bloom Texture"
        cloudBloomRenderPipeline.vertexFunction = vertexProgram
        cloudBloomRenderPipeline.fragmentFunction = cloudBloomFragmentProgram
        cloudBloomRenderPipeline.sampleCount = view.sampleCount
        
        cloudBloomRenderPipeline.colorAttachments[0] = colorAttachmentDescriptor
        cloudBloomRenderPipeline.colorAttachments[1] = colorAttachmentDescriptor
        
        // =============== Compute Shaders ================
        let addComputeProgram = defaultLibrary.makeFunction(name: "addShader")!
        
        //compile the pipelines
        do {
            try addComputePipelineState =
                device.makeComputePipelineState(function: addComputeProgram)
            try plainRenderPipelineState = device.makeRenderPipelineState(descriptor: plainRenderPipeline)
            try cloudBloomRenderPipelineState = device.makeRenderPipelineState(descriptor: cloudBloomRenderPipeline)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
    }
    
}
