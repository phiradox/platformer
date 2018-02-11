//
//  GraphicsOptionsView.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/27/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

class GraphicsOptionsView: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = nil
        if indexPath.row >= options.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "OK")!
        } else {
            switch options[indexPath.row].type {
            case .toggle:
                let toggleCell = (tableView.dequeueReusableCell(withIdentifier: "Toggle") as! ToggleCell)
                toggleCell.option!.text = options[indexPath.row].label
                cell = toggleCell
            case .slider:
                let sliderCell = (tableView.dequeueReusableCell(withIdentifier: "Slider") as! SliderCell)
                sliderCell.option!.text = options[indexPath.row].label
                cell = sliderCell
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    enum OptionsType {
        case toggle
        case slider
    }
    
    let options: [(label: String, type: OptionsType)] = [
        ("Menu Clouds", .toggle),
        ("Menu Cloud Blur", .toggle),
        ("Menu Cloud Blur Amount", .slider),
        ("Shadows", .toggle),
        ("Shadow Blur", .toggle),
        ("Shadow Blur Amount", .slider),
        ("Ambience", .toggle),
        ("Ambience Blur", .toggle),
        ("Ambience Blur Amount", .slider),
        ("Ambience Particle Count", .slider)
    ]
}

class ToggleCell: UITableViewCell {
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var toggle: UISwitch!
}

class SliderCell: UITableViewCell {
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var slider: UISlider!
}

class OkayCell: UITableViewCell {
    @IBAction func ok(_ sender: Any?) {
        // save options and go back to other view
    }
}
