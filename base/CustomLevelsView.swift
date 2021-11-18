//
//  LevelTableView.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/26/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit
import MetalKit

class CustomLevelsView: UIScrollView, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SaveData.levels.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let levelTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "Level") as! LevelTableViewCell)
        levelTableViewCell.level = indexPath.row
        levelTableViewCell.levelName!.text = SaveData.levels[indexPath.row].name
        return levelTableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func newLevel(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "Game") as! GameViewController
        GlobalVars.currentViewController.present(gameViewController, animated: true, completion: nil)
        LevelEditorScene.levelBeingEditted = SaveData.levels.count
        let levelEditorScene = LevelEditorScene(of: gameViewController.view.frame.size.toSize(), and: GlobalVars.tileSize, in: gameViewController.scene.view, and: gameViewController, device: gameViewController.device)
        gameViewController.present(levelEditorScene)
    }
    
}

class LevelTableViewCell: UITableViewCell {
    var level: Int! = nil
    @IBOutlet var levelName: UILabel?
    @IBAction func deleteLevel(_ sender: Any?) {
        //SaveData.levels.remove(at: level)
    }
    @IBAction func editLevel(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "Game") as! GameViewController
        GlobalVars.currentViewController.present(gameViewController, animated: true, completion: nil)
        LevelEditorScene.levelBeingEditted = level
        let levelEditorScene = LevelEditorScene(of: gameViewController.view.frame.size.toSize(), and: GlobalVars.tileSize, in: gameViewController.scene.view, and: gameViewController, device: gameViewController.device)
        gameViewController.present(levelEditorScene)
    }
    @IBAction func playLevel(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "Game") as! GameViewController
        GlobalVars.currentViewController.present(gameViewController, animated: true, completion: nil)
        (gameViewController.scene as! GameScene).levelManager.loadLevel(SaveData.levels[level])
    }
}
