//
//  SaveData.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/1/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import os.log

class SaveData {
    
    static var levels: [Level] = []
    static var options: Options! = nil
    
    static func saveLevels() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(levels, toFile: Level.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Levels successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Levels did not save properly...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadLevels() {
        levels = []
        if let loadedLevels = NSKeyedUnarchiver.unarchiveObject(withFile: Level.ArchiveURL.path) as? [Level] {
            levels.append(contentsOf: loadedLevels)
        }
    }
    
    static func saveOptions() {
        print(Options.shadowsBool.pointee)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(options, toFile: Options.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Options successfully saved.", log: OSLog.default, type: .debug)
            
        } else {
            os_log("Options did not save properly...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadOptions() {
        if let loadedOptions = NSKeyedUnarchiver.unarchiveObject(withFile: Options.ArchiveURL.path) as? Options {
            options = loadedOptions
        }
        if options == nil {
            options = Options()
            Options.setDefaultProperties()
        }
    }
    
}
