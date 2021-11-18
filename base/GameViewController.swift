//
//  GameViewController.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 10/16/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import UIKit
import Metal
import MetalKit
import MetalPerformanceShaders
import AVFoundation
import AudioToolbox

class GameViewController: UIViewController, MTKViewDelegate {
    
    @objc var audioPlayer: AVAudioPlayer! = nil
    
    @objc var device: MTLDevice! = nil
    
    @objc var projectionMatrix: [Float] = []
    @objc var commandQueue: MTLCommandQueue! = nil
    var renderer: Renderer! = nil
    
    var scene: Scene! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveData.loadOptions()
        
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {
            print("Metal is not supported on this device")
            self.view = UIView(frame: self.view.frame)
            return
        }
        GlobalVars.device = device
        
        // setup view properties
        let view = self.view as! MTKView
        view.device = device
        view.delegate = self
        view.framebufferOnly = false
        
        let tileSize = 10 * Float(view.contentScaleFactor)
        GlobalVars.tileSize = tileSize
        
        // projection matrix
        let m11: Float = 2/self.view.frame.size.toSize().width
        let m22: Float = 2/self.view.frame.size.toSize().height
        projectionMatrix = [
            m11, 0,   0, 0,
            0,   m22, 0, 0,
            0,   0,   1, 0,
            0,   0,   0, 1
        ]
        
        // prepare for rendering
        renderer = Renderer(with: device, projectionMatrix: projectionMatrix)
        
        // set up game scene
        present(GameScene(of: self.view.frame.size.toSize(), and: tileSize, in: view, and: self, device: device))
        
        commandQueue = device.makeCommandQueue()
        commandQueue.label = "Main command queue :)"
    }
    
    @objc func play(sound url: URL, looped loops: Int) {
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer = sound
            sound.numberOfLoops = loops
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("Error playing main menu loop")
        }
    }
    
    func draw(in view: MTKView) {
        scene.update()
        scene.render(with: renderer, and: commandQueue)
    }
    
    func present(_ scene: Scene) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        self.scene = scene
        GlobalVars.currentScene = scene
        self.scene.prepare()
        self.scene.present()
        self.scene.compile()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesEnded(touches, with: event)
    }
}
