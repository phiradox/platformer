//
//  Menus.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 7/31/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Menus {
    
    enum Menu {
        case mainMenu
        case playMenu
        case editorMenu
        case saveLevelMenu
        case levelOptionsMenu
        case optionsMain
        case graphicsOptions
        case gameOptions
    }
    
    static var globalUIColor: Color = Color(r: 0.7, g: 0.7, b: 0.7, a: 1)
    
    static func prepare(_ menu: Menu, in node: Node, in scene: Scene) {
        node.zPosition = -10
        switch menu {
        case .mainMenu:
            // MARK: Main Menu
            let menuScene = (scene as! MenuScene)
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            let textContainer = Node()
            let platformerText = TextNode(of: "PLATFORMER", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            platformerText.compile()
            platformerText.position = Point(x: -platformerText.size.width/2, y: -platformerText.size.height/2)
            textContainer.addChild(platformerText)
            textContainer.position = Point(x: 0, y: menuScene.size.height/4)
            
            node.addChild(textContainer)
            
            let playButton = Button()
            let playText = TextNode(of: "PLAY", madeOf: block, sized: GlobalVars.tileSize*1, at: Point(x: 0, y: 0))
            playText.compile()
            playText.position = Point(x: -playText.size.width/2, y: -playText.size.height/2)
            playButton.addChild(playText)
            let playScript = {() -> () in
                /*let gameScene = GameScene(of: scene.size, and: scene.tileSize, in: scene.view, and: scene.gameViewController, device: scene.device)
                scene.gameViewController.present(gameScene)*/
                let newNode = Node()
                Menus.prepare(.playMenu, in: newNode, in: menuScene)
                newNode.geometry.dynamic = true
                newNode.position.x = menuScene.size.width
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            playButton.spawn(in: node, at: Point(x: 0, y: 0), withSize: Size(width: playText.size.width, height: playText.size.height), onTouch: playScript)
            playButton.geometry.vertices = []
            playButton.label = "Play button"
            
            let optionsButton = Button()
            let optionsText = TextNode(of: "OPTIONS", madeOf: block, sized: GlobalVars.tileSize, at: Point(x: 0, y: 0))
            optionsText.compile()
            optionsText.position = Point(x: -optionsText.size.width/2, y: -optionsText.size.height/2)
            optionsButton.addChild(optionsText)
            let optionsScript = {() -> () in
                let newNode = Node()
                self.prepare(.optionsMain, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = -menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            optionsButton.spawn(in: node, at: Point(x: 0, y: -menuScene.size.height/4), withSize: Size(width: optionsText.size.width, height: optionsText.size.height), onTouch: optionsScript)
            optionsButton.geometry.vertices = []
            optionsButton.label = "Play button"
            
        case .playMenu:
            // MARK: Play Menu
            
            let back = [
                "    X",
                "  XX ",
                "XX   ",
                "  XX ",
                "    X"
            ]
            
            let menuScene = (scene as! MenuScene)
            var block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            let adventureText = TextNode(of: "ADVENTURE", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            adventureText.compile()
            adventureText.position = Point(x: -adventureText.size.width/2, y: -adventureText.size.height/2)
            let adventureButton = Button()
            adventureButton.addChild(adventureText)
            let adventureScript = {() -> () in
                menuScene.scrollView.removeFromSuperview()
                menuScene.gameViewController.present(GameScene(of: menuScene.size, and: menuScene.tileSize, in: menuScene.view, and: menuScene.gameViewController, device: menuScene.device))
            }
            adventureButton.spawn(in: node, at: Point(x: 0, y: menuScene.size.height/4), withSize: adventureText.size, onTouch: adventureScript)
            adventureButton.geometry.vertices = []
            adventureButton.label = "Adventure Button"
            
            block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            let backButton = Button()
            let backScript = {() -> () in
                let newNode = Node()
                self.prepare(.mainMenu, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.x = -menuScene.size.width
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            Rasterizer.rasterize(back, repeating: block, sized: menuScene.tileSize/2, in: backButton)
            backButton.spawn(in: node, at: Point(x: -menuScene.size.width/2 + backButton.size.width, y: menuScene.size.height/2 - backButton.size.height), withSize: Size(width: backButton.size.width, height: backButton.size.height), onTouch: backScript)
            backButton.geometry.vertices = []
            backButton.label = "Back Button"
            
            // Level editor button
            
            let customLevelsText = TextNode(of: "CUSTOM LEVELS", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            customLevelsText.compile()
            customLevelsText.position = Point(x: -customLevelsText.size.width/2, y: -customLevelsText.size.height/2)
            
             let customLevelsButton = Button()
             let customLevelsScript = {() -> () in
                let newNode = Node()
                self.prepare(.editorMenu, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = -menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
             }
            customLevelsButton.addChild(customLevelsText)
            customLevelsButton.spawn(in: node, at: Point(x: 0, y: -menuScene.size.height/4), withSize: Size(width: customLevelsText.size.width, height: customLevelsText.size.height), onTouch: customLevelsScript)
             customLevelsButton.geometry.vertices = []
            
            // endless button
            
            /*let endlessText = TextNode(of: "ENDLESS", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            endlessText.compile()
            endlessText.position = Point(x: -endlessText.size.width/2, y: -endlessText.size.height/2)
            
            let endlessButton = Button()
            let endlessScript = {() -> () in
                print("endless button pressed")
            }
            endlessButton.addChild(endlessText)
            endlessButton.spawn(in: node, at: Point(x: 0, y: 0), withSize: Size(width: endlessText.size.width, height: endlessText.size.height), onTouch: endlessScript)
            endlessButton.geometry.vertices = []*/
        case .editorMenu:
            // MARK: Editor Menu
            SaveData.loadLevels()
            
            let back = [
                "  X  ",
                "  X  ",
                " X X ",
                " X X ",
                "X   X"
            ]
            let menuScene = scene as! MenuScene
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            let backButton = Button()
            let backScript = {() -> () in
                let newNode = Node()
                self.prepare(.playMenu, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            Rasterizer.rasterize(back, repeating: block, sized: menuScene.tileSize/2, in: backButton)
            backButton.spawn(in: node, at: Point(x: -menuScene.size.width/2 + backButton.size.width, y: menuScene.size.height/2 - backButton.size.height), withSize: Size(width: backButton.size.width, height: backButton.size.height), onTouch: backScript)
            backButton.geometry.vertices = []
            backButton.label = "Back Button"
            
            let newLevel = [
                "  X  ",
                "  X  ",
                "XXXXX",
                "  X  ",
                "  X  "
            ]
            
            let newLevelButton = Button()
            let newLevelScript = {() -> () in
                LevelEditorScene.levelBeingEditted = SaveData.levels.count
                menuScene.gameViewController.present(LevelEditorScene(of: menuScene.size, and: menuScene.tileSize, in: menuScene.view, and: menuScene.gameViewController, device: menuScene.device))
            }
            Rasterizer.rasterize(newLevel, repeating: block, sized: menuScene.tileSize/2, in: newLevelButton)
            newLevelButton.spawn(in: node, at: Point(x: menuScene.size.width/2 - newLevelButton.size.width, y: menuScene.size.height/2 - newLevelButton.size.height), withSize: Size(width: newLevelButton.size.width, height: newLevelButton.size.height), onTouch: newLevelScript)
            newLevelButton.geometry.vertices = []
            newLevelButton.label = "New Level Button"
            
            let cellHeight: Float = menuScene.tileSize * 1.5
            let cellSpacing: Float = menuScene.tileSize
            
            let playLevel = ["X    ", "XXX  ", "XXXXX", "XXX  ", "X    "]
            let deleteLevel = ["X   X", " X X ", "  X  ", " X X ", "X   X"]
            let editLevel = ["XXX X",
                             "X  X ",
                             "X X X",
                             "X   X",
                             "XXXXX"]
            
            SaveData.loadLevels()
            var offSetY: Float = 0
            for (n, level) in SaveData.levels.enumerated() {
                offSetY = menuScene.size.height/2-((cellHeight + cellSpacing) * Float(n) + 3*cellHeight)
                // the text of the level name
                block.geometry.color = Menus.globalUIColor
                let levelText = TextNode(of: level.name, madeOf: block, sized: cellHeight, at: Point(x: -scene.size.width/2 + cellHeight, y: offSetY - cellHeight))
                levelText.geometry.vertices = []
                levelText.compile()
                node.addChild(levelText)
                // the play button for IT ALL
                let playLevelButton = Button()
                let playLevelScript = {() -> () in
                    let gameScene = GameScene(of: menuScene.size, and: menuScene.tileSize, in: menuScene.view, and: menuScene.gameViewController, device: menuScene.device)
                    menuScene.gameViewController.present(gameScene)
                    gameScene.levelManager.loadLevel(level)
                    gameScene.geometry.masterCompile()
                    print(level.level)
                    print(level.background)
                    print(level.ambience)
                }
                block.geometry.color = Color(r: 0, g: 1.0, b: 0, a: 1)
                Rasterizer.rasterize(playLevel, repeating: block, sized: cellHeight/Float(playLevel.count), in: playLevelButton)
                playLevelButton.spawn(in: node, at: Point(x: menuScene.size.width/2 - playLevelButton.size.width, y: offSetY - playLevelButton.size.height/2), withSize: Size(width: playLevelButton.size.width, height: playLevelButton.size.height), onTouch: playLevelScript)
                playLevelButton.geometry.vertices = []
                playLevelButton.label = "Play Level Button for: " + level.name
                
                // the delete level button
                let deleteLevelButton = Button()
                let deleteLevelScript = {() -> () in
                    let coverNode = Node()
                    coverNode.size = scene.size
                    coverNode.geometry.vertices = Rectangle(size: coverNode.size, color: Color(r: 0.5, g: 0.0, b: 0.0, a: 0.6)).toVertices()
                    coverNode.geometry.dynamic = true
                    coverNode.zPosition = -100
                    coverNode.label = "Cover Node"
                    menuScene.UI.addChild(coverNode)
                    GlobalVars.activeUINode = coverNode
                    
                    block.geometry.color = Color(r: 1.0, g: 0, b: 1.0, a: 1.0)
                    let deleteText = TextNode(of: "Are you sure you want to delete", madeOf: block, sized: GlobalVars.tileSize*1, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*2, y: menuScene.size.height/2 - GlobalVars.tileSize*2))
                    coverNode.addChild(deleteText)
                    deleteText.compile()
                    
                    let levelNameText = TextNode(of: level.name + "?", madeOf: block, sized: GlobalVars.tileSize*1.5, at: Point(x: deleteText.position.x, y: deleteText.position.y - deleteText.size.height - GlobalVars.tileSize*1.5))
                    coverNode.addChild(levelNameText)
                    levelNameText.compile()
                    
                    let yes = Button()
                    let block = Block()
                    block.size = Size(width: GlobalVars.tileSize, height: GlobalVars.tileSize)
                    block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
                    let yesText = TextNode(of: "YES", madeOf: block, sized: GlobalVars.tileSize*3, at: Point(x: 0, y: 0))
                    yesText.compile()
                    yesText.position.x = -yesText.size.width/2
                    yesText.position.y = -yesText.size.height/2
                    yes.addChild(yesText)
                    yes.position = Point(x: -scene.size.width/4, y: -scene.size.height/4)
                    yes.zPosition = 1
                    yes.size = yesText.size
                    coverNode.addChild(yes)
                    yes.onRelease = {() -> () in
                        SaveData.levels.remove(at: n)
                        SaveData.saveLevels()
                        coverNode.removeFromParent()
                        node.removeAllChildren()
                        GlobalVars.activeUINode = menuScene.UI
                        self.prepare(.editorMenu, in: node, in: menuScene)
                        menuScene.geometry.masterCompile()
                    }
                    
                    let no = Button()
                    let noText = TextNode(of: "NO", madeOf: block, sized: GlobalVars.tileSize*3, at: Point(x: 0, y: 0))
                    noText.compile()
                    noText.position.y = -noText.size.height/2
                    noText.position.x = -noText.size.width/2
                    no.addChild(noText)
                    no.position = Point(x: scene.size.width/4, y: -scene.size.height/4)
                    no.zPosition = 1
                    no.size = noText.size
                    coverNode.addChild(no)
                    no.onRelease = {() -> () in
                        coverNode.removeFromParent()
                        GlobalVars.activeUINode = menuScene.UI
                    }
                }
                block.geometry.color = Color(r: 1, g: 0.0, b: 0, a: 1)
                Rasterizer.rasterize(deleteLevel, repeating: block, sized: cellHeight/Float(deleteLevel.count), in: deleteLevelButton)
                deleteLevelButton.spawn(in: node, at: Point(x: playLevelButton.position.x - deleteLevelButton.size.width  - cellHeight/Float(deleteLevel.count)*3, y: offSetY - deleteLevelButton.size.height/2), withSize: Size(width: deleteLevelButton.size.width, height: deleteLevelButton.size.height), onTouch: deleteLevelScript)
                deleteLevelButton.geometry.vertices = []
                deleteLevelButton.label = "Delete Level Button for: " + level.name
                
                // edit level button
                let editLevelButton = Button()
                let editLevelScript = {() -> () in
                    LevelEditorScene.levelBeingEditted = n
                    let levelEditorScene = LevelEditorScene(of: menuScene.size, and: menuScene.tileSize, in: menuScene.view, and: menuScene.gameViewController, device: menuScene.device)
                    menuScene.gameViewController.present(levelEditorScene)
                }
                block.geometry.color = Color(r: 1.0, g: 1.0, b: 0, a: 1)
                Rasterizer.rasterize(editLevel, repeating: block, sized: cellHeight/Float(editLevel.count), in: editLevelButton)
                editLevelButton.spawn(in: node, at: Point(x: deleteLevelButton.position.x - editLevelButton.size.width - cellHeight/Float(editLevel.count)*3, y: offSetY - editLevelButton.size.height/2), withSize: Size(width: editLevelButton.size.width, height: editLevelButton.size.height), onTouch: editLevelScript)
                editLevelButton.geometry.vertices = []
                editLevelButton.label = "Edit Level Button for: \"" + level.name + "\""
                
            }
            node.size.width = menuScene.size.width
            offSetY -= cellHeight + cellSpacing
            node.size.height = menuScene.size.height/2 - offSetY
            menuScene.scrollView.movingNode = node
        case .saveLevelMenu:
            // MARK: Save Level Menu
            node.geometry.dynamic = true
            node.zPosition = -100
            node.geometry.vertices = Rectangle(size: scene.size, color: Color(r: 0.0, g: 0.0, b: 0.0, a: 0.5)).toVertices()
            
            let levelEditorScene = (scene as! LevelEditorScene)
            levelEditorScene.blockSelectionMenu.removeFromSuperview()
            levelEditorScene.levelScrollView.removeFromSuperview()
            
            var block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: scene.tileSize/2, height: scene.tileSize/2)
            var placeHolderText = "LEVEL NAME"
            if LevelEditorScene.levelBeingEditted < SaveData.levels.count {
                if let levelName = SaveData.levels[LevelEditorScene.levelBeingEditted].name {
                    placeHolderText = levelName
                }
            }
            
            let textInputNode = TextInputNode(of: placeHolderText, madeOf: block, sized: scene.tileSize*1.5, at: Point(x: -scene.size.width/2 + scene.tileSize, y: scene.size.height/2-scene.tileSize*4))
            
            textInputNode.compile()
            
            TextInput.initializeInView(scene.view.superview!)
            TextInput.attachedNode = textInputNode
            TextInput.enableKeyboard()
            node.addChild(textInputNode)
            
            let saveShape = ["  X  ", "  X  ", "XXXXX", " XXX ", "  X  "]
            let saveButton = Button()
            block = Block()
            block.geometry.color = Color(r: 0.0, g: 0.0, b: 1.0, a: 0.5)
            block.size = Size(width: scene.tileSize/2, height: scene.tileSize/2)
            
            Rasterizer.rasterize(saveShape, repeating: block, sized: scene.tileSize/2, in: saveButton)
            
            let saveButtonClosure = { () -> () in
                let level = levelEditorScene.level!
                level.name = textInputNode.text
                level.level = levelEditorScene.genLevel()
                SaveData.loadLevels()
                if LevelEditorScene.levelBeingEditted >= SaveData.levels.count {
                    SaveData.levels.append(level)
                } else {
                    SaveData.levels[LevelEditorScene.levelBeingEditted] = level
                }
                SaveData.saveLevels()
                let menuScene = MenuScene(of: levelEditorScene.size, and: scene.tileSize, in: scene.view, and: scene.gameViewController, device: scene.device)
                scene.gameViewController.present(menuScene)
                TextInput.disableKeyboard()
                TextInput.destroyInput()
                menuScene.UI.removeAllChildren()
                Menus.prepare(.editorMenu, in: menuScene.UI, in: menuScene)
            }
            saveButton.spawn(in: node, at: Point(x: scene.size.width/2 - saveButton.size.width*2, y: scene.size.height/2-scene.tileSize*4 + saveButton.size.height/2), withSize: saveButton.size, onTouch: saveButtonClosure)
            saveButton.geometry.vertices = []
        case .levelOptionsMenu:
            // MARK: Level Options Menu
            node.geometry.dynamic = true
            node.zPosition = -100
            node.geometry.vertices = Rectangle(size: scene.size, color: Color(r: 0.0, g: 0.0, b: 0.0, a: 0.5)).toVertices()
            
            let levelEditorScene = (scene as! LevelEditorScene)
            levelEditorScene.blockSelectionMenu.removeFromSuperview()
            levelEditorScene.levelScrollView.removeFromSuperview()
            
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: scene.tileSize, height: scene.tileSize)
            
            let levelColorsText = TextNode(of: "Level Colors-", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: -scene.size.width/2 + GlobalVars.tileSize, y: scene.size.height/2 - GlobalVars.tileSize*3))
            levelColorsText.compile()
            node.addChild(levelColorsText)
            
            let backgroundText = TextNode(of: "Background", madeOf: block, sized: GlobalVars.tileSize*1.5, at: Point(x: 0, y: 0))
            backgroundText.compile()
            backgroundText.position.x = -scene.size.width/2 + GlobalVars.tileSize
            backgroundText.position.y = -backgroundText.size.height/2 + (scene.size.height - levelColorsText.size.height)/4
            node.addChild(backgroundText)
            
            let ambienceText = TextNode(of: "Ambience", madeOf: block, sized: GlobalVars.tileSize*1.5, at: Point(x: 0, y: 0))
            ambienceText.compile()
            ambienceText.position.x = -scene.size.width/2 + GlobalVars.tileSize
            ambienceText.position.y = -ambienceText.size.height/2 + (scene.size.height - levelColorsText.size.height)/8
            node.addChild(ambienceText)
            
            let mainBlockText = TextNode(of: "Main Block", madeOf: block, sized: GlobalVars.tileSize*1.5, at: Point(x: 0, y: 0))
            mainBlockText.compile()
            mainBlockText.position.x = -scene.size.width/2 + GlobalVars.tileSize
            mainBlockText.position.y = -mainBlockText.size.height/2 - (scene.size.height - levelColorsText.size.height)/8
            node.addChild(mainBlockText)
            
            let secondaryBlockText = TextNode(of: "Secondary Block", madeOf: block, sized: GlobalVars.tileSize*1.5, at: Point(x: 0, y: 0))
            secondaryBlockText.compile()
            secondaryBlockText.position.x = -scene.size.width/2 + GlobalVars.tileSize
            secondaryBlockText.position.y = -secondaryBlockText.size.height/2 - (scene.size.height - levelColorsText.size.height)/4
            node.addChild(secondaryBlockText)
        case .optionsMain:
            let menuScene = (scene as! MenuScene)
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            // back button
            let back = [
                "  X  ",
                "  X  ",
                " X X ",
                " X X ",
                "X   X"
            ]
            let backButton = Button()
            let backScript = {() -> () in
                let newNode = Node()
                self.prepare(.mainMenu, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            Rasterizer.rasterize(back, repeating: block, sized: menuScene.tileSize/2, in: backButton)
            backButton.spawn(in: node, at: Point(x: -menuScene.size.width/2 + backButton.size.width, y: menuScene.size.height/2 - backButton.size.height), withSize: Size(width: backButton.size.width, height: backButton.size.height), onTouch: backScript)
            backButton.geometry.vertices = []
            backButton.label = "Back Button"
            
            // graphics text button
            let graphicsButton = Button()
            let graphicsText = TextNode(of: "GRAPHICS", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            graphicsText.compile()
            graphicsText.position = Point(x: -graphicsText.size.width/2, y: -graphicsText.size.height/2)
            graphicsButton.addChild(graphicsText)
            let graphicsScript = {() -> () in
                let newNode = Node()
                self.prepare(.graphicsOptions, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.x = -menuScene.size.width
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            graphicsButton.spawn(in: node, at: Point(x: 0, y: menuScene.size.height/4), withSize: Size(width: graphicsText.size.width, height: graphicsText.size.height), onTouch: graphicsScript)
            graphicsButton.geometry.vertices = []
            graphicsButton.label = "Graphics options button"
            
            let gameButton = Button()
            let gameText = TextNode(of: "GAME", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            gameText.compile()
            gameText.position = Point(x: -gameText.size.width/2, y: -gameText.size.height/2)
            gameButton.addChild(gameText)
            let gameScript = {() -> () in
                let newNode = Node()
                self.prepare(.gameOptions, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = node.position.y - menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            gameButton.spawn(in: node, at: Point(x: 0, y: 0), withSize: Size(width: gameText.size.width, height: gameText.size.height), onTouch: gameScript)
            gameButton.geometry.vertices = []
            gameButton.label = "Game options button"
        case .graphicsOptions:
            let menuScene = (scene as! MenuScene)
            
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            let cellHeight = GlobalVars.tileSize*1.5
            let cellSpacing = GlobalVars.tileSize*1 + cellHeight
            
            let cloudsEnableText = TextNode(of: "Menu Clouds", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: menuScene.size.height/2 - GlobalVars.tileSize*1.5))
            cloudsEnableText.compile()
            cloudsEnableText.position.y -= cloudsEnableText.size.height
            node.addChild(cloudsEnableText)
            let cloudsToggle = Toggle(of: Options.cloudsBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
            cloudsToggle.position = Point(x: menuScene.size.width/2 - cloudsToggle.size.width, y: cloudsEnableText.position.y + cloudsToggle.size.height/2)
            node.addChild(cloudsToggle)
            
            let cloudBlurEnableText = TextNode(of: "* Cloud Blur", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: cloudsEnableText.position.y-cellSpacing))
            cloudBlurEnableText.compile()
            node.addChild(cloudBlurEnableText)
            let cloudBlurToggle = Toggle(of: Options.cloudBlurBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
            cloudBlurToggle.position = Point(x: menuScene.size.width/2 - cloudBlurToggle.size.width, y: cloudBlurEnableText.position.y + cloudBlurToggle.size.height/2)
            node.addChild(cloudBlurToggle)
            
            let cloudBlurIntensityText = TextNode(of: "* Cloud Blur Intensity", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: cloudBlurEnableText.position.y-cellSpacing))
            cloudBlurIntensityText.compile()
            node.addChild(cloudBlurIntensityText)
            let cloudBlurIntensitySlider = Slider(in: node, of: Options.cloudBlurIntensity, boundedFrom: 0, to: 50, sized: Size(width: menuScene.size.width/3*2, height: GlobalVars.tileSize*1.5), withSliderColored: Menus.globalUIColor, andBarColored: Color(r: 0.5, g: 0.5, b: 0.5, a: 1.0))
            cloudBlurIntensitySlider.position = Point(x: 0, y: cloudBlurIntensityText.position.y - cellSpacing/2)
            
            let shadowsEnableText = TextNode(of: "Shadows", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: cloudBlurIntensitySlider.position.y - cellSpacing - cloudBlurIntensitySlider.size.height/2))
            shadowsEnableText.compile()
            shadowsEnableText.position.y -= shadowsEnableText.size.height
            node.addChild(shadowsEnableText)
            let shadowsToggle = Toggle(of: Options.shadowsBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
            shadowsToggle.position = Point(x: menuScene.size.width/2 - shadowsToggle.size.width, y: shadowsEnableText.position.y + shadowsToggle.size.height/2)
            node.addChild(shadowsToggle)
            
            let shadowBlurEnableText = TextNode(of: "* Shadow Blur", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: shadowsEnableText.position.y-cellSpacing))
            shadowBlurEnableText.compile()
            node.addChild(shadowBlurEnableText)
            let shadowBlurToggle = Toggle(of: Options.shadowBlurBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0))
            shadowBlurToggle.position = Point(x: menuScene.size.width/2 - shadowBlurToggle.size.width, y: shadowBlurEnableText.position.y + shadowBlurToggle.size.height/2)
            node.addChild(shadowBlurToggle)
            
            let shadowBlurIntensityText = TextNode(of: "* Shadow Blur Intensity", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: shadowBlurEnableText.position.y-cellSpacing))
            shadowBlurIntensityText.compile()
            node.addChild(shadowBlurIntensityText)
            let shadowBlurIntensitySlider = Slider(in: node, of: Options.shadowBlurIntensity, boundedFrom: 0, to: 20, sized: Size(width: menuScene.size.width/3*2, height: GlobalVars.tileSize*1.5), withSliderColored: Menus.globalUIColor, andBarColored: Color(r: 0.5, g: 0.5, b: 0.5, a: 1.0))
            shadowBlurIntensitySlider.position = Point(x: 0, y: shadowBlurIntensityText.position.y - cellSpacing/2)
            
            let ambienceEnableText = TextNode(of: "Ambience", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: shadowBlurIntensitySlider.position.y - cellSpacing - shadowBlurIntensitySlider.size.height/2))
            ambienceEnableText.compile()
            node.addChild(ambienceEnableText)
            let ambienceEnableToggle = Toggle(of: Options.ambienceBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0, g: 1.0, b: 0.0, a: 1.0))
            ambienceEnableToggle.position = Point(x: menuScene.size.width/2 - ambienceEnableToggle.size.width, y: ambienceEnableText.position.y + ambienceEnableToggle.size.height/2)
            node.addChild(ambienceEnableToggle)
            
            let ambienceBlurEnableText = TextNode(of: "* Ambience Blur", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: ambienceEnableText.position.y - cellSpacing))
            ambienceBlurEnableText.compile()
            node.addChild(ambienceBlurEnableText)
            let ambienceBlurEnableToggle = Toggle(of: Options.ambienceBlurBool, sized: cellHeight, borderColor: Menus.globalUIColor, inactiveColor: Color(r: 0.5, g: 0.5, b: 0.5, a: 0.5), activeColor: Color(r: 0, g: 1.0, b: 0.0, a: 1.0))
            ambienceBlurEnableToggle.position = Point(x: menuScene.size.width/2 - ambienceBlurEnableToggle.size.width, y: ambienceBlurEnableText.position.y + ambienceBlurEnableToggle.size.height/2)
            node.addChild(ambienceBlurEnableToggle)
            
            let ambienceBlurIntensityText = TextNode(of: "* Ambience Blur Intensity", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: ambienceBlurEnableText.position.y-cellSpacing))
            ambienceBlurIntensityText.compile()
            node.addChild(ambienceBlurIntensityText)
            let ambienceBlurIntensitySlider = Slider(in: node, of: Options.ambienceBlurIntensity, boundedFrom: 0, to: 20, sized: Size(width: menuScene.size.width/3*2, height: GlobalVars.tileSize*1.5), withSliderColored: Menus.globalUIColor, andBarColored: Color(r: 0.5, g: 0.5, b: 0.5, a: 1.0))
            ambienceBlurIntensitySlider.position = Point(x: 0, y: ambienceBlurIntensityText.position.y - cellSpacing/2)
            
            let ambienceParticleCountText = TextNode(of: "* Ambience Particle Count", madeOf: block, sized: cellHeight, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*1.5, y: ambienceBlurIntensitySlider.position.y-cellSpacing - ambienceBlurIntensitySlider.size.height/2))
            ambienceParticleCountText.compile()
            node.addChild(ambienceParticleCountText)
            let ambienceParticleCountSlider = Slider(in: node, of: Options.ambienceParticleCount, boundedFrom: 128, to: 8192, sized: Size(width: menuScene.size.width/3*2, height: GlobalVars.tileSize*1.5), withSliderColored: Menus.globalUIColor, andBarColored: Color(r: 0.5, g: 0.5, b: 0.5, a: 1.0))
            ambienceParticleCountSlider.position = Point(x: 0, y: ambienceParticleCountText.position.y - cellSpacing/2)
            
            let okText = TextNode(of: "OK", madeOf: block, sized: cellHeight*2, at: Point(x: 0, y: 0))
            okText.compile()
            let ok = Button()
            ok.addChild(okText)
            okText.position = Point(x: -okText.size.width/2, y: -okText.size.height/2)
            let okScript = {() -> () in
                SaveData.saveOptions()
                SaveData.loadOptions()
                let newNode = Node()
                self.prepare(.optionsMain, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.x = menuScene.size.width
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                    menuScene.scrollView.contentOffset.y = 0
                })
            }
            ok.spawn(in: node, at: Point(x: 0, y: ambienceParticleCountSlider.position.y - cellSpacing - ok.size.height/2 - ambienceParticleCountSlider.size.height/2), withSize: okText.size, onTouch: okScript)
            ok.geometry.vertices = []
            
            node.size = Size(width: menuScene.size.width, height: menuScene.size.height/2 - ok.position.y + cellSpacing - cellHeight + ok.size.height/2)
            menuScene.scrollView.movingNode = node
        case .gameOptions:
            let menuScene = (scene as! MenuScene)
            let block = Block()
            block.geometry.color = Menus.globalUIColor
            block.size = Size(width: menuScene.tileSize/2, height: menuScene.tileSize/2)
            
            // back button
            let back = [
                "  X  ",
                "  X  ",
                " X X ",
                " X X ",
                "X   X"
            ]
            let backButton = Button()
            let backScript = {() -> () in
                let newNode = Node()
                self.prepare(.optionsMain, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.y = menuScene.size.height
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })
            }
            Rasterizer.rasterize(back, repeating: block, sized: menuScene.tileSize/2, in: backButton)
            backButton.spawn(in: node, at: Point(x: -menuScene.size.width/2 + backButton.size.width, y: menuScene.size.height/2 - backButton.size.height), withSize: Size(width: backButton.size.width, height: backButton.size.height), onTouch: backScript)
            backButton.geometry.vertices = []
            backButton.label = "Back Button"
            
            // button to get to controls
            let controlsButton = Button()
            let controlsText = TextNode(of: "CONTROLS", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            controlsText.compile()
            controlsText.position = Point(x: -controlsText.size.width/2, y: -controlsText.size.height/2)
            controlsButton.addChild(controlsText)
            let controlsScript = {() -> () in
                /*let newNode = Node()
                self.prepare(.controlsOptions, in: newNode, in: scene)
                newNode.geometry.dynamic = true
                newNode.position.x = menuScene.size.width
                menuScene.UI.addChild(newNode)
                menuScene.transition = Sweep(from: node, origin: true, to: newNode, duration: 0.5, onCompletion: {() -> () in
                    node.removeFromParent()
                    menuScene.transition = nil
                })*/
            }
            controlsButton.spawn(in: node, at: Point(x: 0, y: menuScene.size.height/8), withSize: Size(width: controlsText.size.width, height: controlsText.size.height), onTouch: controlsScript)
            controlsButton.geometry.vertices = []
            controlsButton.label = "Controls options button"
            
            //button to reset level progress
            block.geometry.color = Color(r: 1, g: 0, b: 0, a: 1)
            let resetProgressButton = Button()
            let resetProgressText = TextNode(of: "RESET PROGRESS", madeOf: block, sized: GlobalVars.tileSize*2, at: Point(x: 0, y: 0))
            resetProgressText.compile()
            resetProgressText.position = Point(x: -resetProgressText.size.width/2, y: -resetProgressText.size.height/2)
            resetProgressButton.addChild(resetProgressText)
            let resetProgressScript = {() -> () in
                let coverNode = Node()
                coverNode.size = scene.size
                coverNode.geometry.vertices = Rectangle(size: coverNode.size, color: Color(r: 0.5, g: 0.0, b: 0.0, a: 0.6)).toVertices()
                coverNode.geometry.dynamic = true
                coverNode.zPosition = -100
                coverNode.label = "Cover Node"
                menuScene.UI.addChild(coverNode)
                GlobalVars.activeUINode = coverNode
                
                block.geometry.color = Color(r: 1.0, g: 0, b: 1.0, a: 1.0)
                let resetText = TextNode(of: "Reset your progress?", madeOf: block, sized: GlobalVars.tileSize*1, at: Point(x: -menuScene.size.width/2 + GlobalVars.tileSize*2, y: menuScene.size.height/2 - GlobalVars.tileSize*2))
                coverNode.addChild(resetText)
                resetText.compile()
                
                let yes = Button()
                let block = Block()
                block.size = Size(width: GlobalVars.tileSize, height: GlobalVars.tileSize)
                block.geometry.color = Color(r: 1, g: 1, b: 1, a: 1)
                let yesText = TextNode(of: "YES", madeOf: block, sized: GlobalVars.tileSize*3, at: Point(x: 0, y: 0))
                yesText.compile()
                yesText.position.x = -yesText.size.width/2
                yesText.position.y = -yesText.size.height/2
                yes.addChild(yesText)
                yes.position = Point(x: -scene.size.width/4, y: -scene.size.height/4)
                yes.zPosition = 1
                yes.size = yesText.size
                coverNode.addChild(yes)
                yes.onRelease = {() -> () in
                    coverNode.removeFromParent()
                    GlobalVars.activeUINode = menuScene.UI
                    GlobalVars.levelProgress = 0
                }
                
                let no = Button()
                let noText = TextNode(of: "NO", madeOf: block, sized: GlobalVars.tileSize*3, at: Point(x: 0, y: 0))
                noText.compile()
                noText.position.y = -noText.size.height/2
                noText.position.x = -noText.size.width/2
                no.addChild(noText)
                no.position = Point(x: scene.size.width/4, y: -scene.size.height/4)
                no.zPosition = 1
                no.size = noText.size
                coverNode.addChild(no)
                no.onRelease = {() -> () in
                    coverNode.removeFromParent()
                    GlobalVars.activeUINode = menuScene.UI
                }
            }
            resetProgressButton.spawn(in: node, at: Point(x: 0, y: -menuScene.size.height/8), withSize: Size(width: resetProgressText.size.width, height: resetProgressText.size.height), onTouch: resetProgressScript)
            resetProgressButton.geometry.vertices = []
            resetProgressButton.label = "Reset progress button"
        }
    }
    
}
