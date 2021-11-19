//
//  Level.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/1/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import os.log

class Level: NSObject, NSCoding {
    
    // MARK: Properties
    
    @objc static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    @objc static let ArchiveURL = DocumentsDirectory.appendingPathComponent("levels")
    
    struct PropertyKey {
        static let name = "name"
        static let level = "level"
        static let levelColors = "levelColors"
    }
    
    @objc var name: String! = nil
    @objc var level: [String]! = nil
    var ambience: Color! = nil {
        didSet {
            levelColors[0] = ambience.r
            levelColors[1] = ambience.g
            levelColors[2] = ambience.b
            levelColors[3] = ambience.a
        }
    }
    var background: Color! = nil {
        didSet {
            levelColors[4] = background.r
            levelColors[5] = background.g
            levelColors[6] = background.b
            levelColors[7] = background.a
        }
    }
    var mainBlockColor: Color! = nil {
        didSet {
            levelColors[8] = mainBlockColor.r
            levelColors[9] = mainBlockColor.g
            levelColors[10] = mainBlockColor.b
            levelColors[11] = mainBlockColor.a
        }
    }
    var secondaryBlockColor: Color! = nil {
        didSet {
            levelColors[12] = secondaryBlockColor.r
            levelColors[13] = secondaryBlockColor.g
            levelColors[14] = secondaryBlockColor.b
            levelColors[15] = secondaryBlockColor.a
        }
    }
    
    private var levelColors: [Float] = []
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(level, forKey: PropertyKey.level)
        aCoder.encode(levelColors, forKey: PropertyKey.levelColors)
    }
    
    init(named name: String, levelData level: [String], ambience: Color, background: Color, mainBlockColor: Color, secondaryBlockColor: Color) {
        self.name = name
        self.level = level
        self.ambience = ambience
        self.background = background
        self.mainBlockColor = mainBlockColor
        self.secondaryBlockColor = secondaryBlockColor
        levelColors = []
        levelColors.append(contentsOf: [ambience.r, ambience.g, ambience.b, ambience.a, background.r, background.g, background.b, background.a, mainBlockColor.r, mainBlockColor.g, mainBlockColor.b, mainBlockColor.a, secondaryBlockColor.r, secondaryBlockColor.g, secondaryBlockColor.b, secondaryBlockColor.a])
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for a level.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let level = aDecoder.decodeObject(forKey: PropertyKey.level) as? [String]
            else {
                os_log("Unable to decode the level data array for a level", log: OSLog.default, type: .debug)
                return nil
        }
        guard let levelColors = aDecoder.decodeObject(forKey: PropertyKey.levelColors) as? [Float]
            else {
                os_log("Unable to decode the level colors for a level", log: OSLog.default, type: .debug)
                return nil
        }
        if levelColors.count < 16 {
            return nil
        }
        let ambience = Color(r: levelColors[0], g: levelColors[1], b: levelColors[2], a: levelColors[3])
        let background = Color(r: levelColors[4], g: levelColors[5], b: levelColors[6], a: levelColors[7])
        let mainBlockColor = Color(r: levelColors[8], g: levelColors[9], b: levelColors[10], a: levelColors[11])
        let secondaryBlockColor = Color(r: levelColors[12], g: levelColors[13], b: levelColors[14], a: levelColors[15])
        
        self.init(named: name, levelData: level, ambience: ambience, background: background, mainBlockColor: mainBlockColor, secondaryBlockColor: secondaryBlockColor)
    }
    
}
