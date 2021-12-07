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
                toggleCell.toggle.isOn = (options[indexPath.row].data[0] as! UnsafeMutablePointer<Bool>).pointee
                toggleCell.index = indexPath.row
                cell = toggleCell
            case .slider:
                let sliderCell = (tableView.dequeueReusableCell(withIdentifier: "Slider") as! SliderCell)
                sliderCell.option!.text = options[indexPath.row].label
                sliderCell.slider.minimumValue = Float(options[indexPath.row].data[1] as! Int)
                sliderCell.slider.maximumValue = Float(options[indexPath.row].data[2] as! Int)
                sliderCell.slider.value = (options[indexPath.row].data[0] as! UnsafeMutablePointer<Float>).pointee
                sliderCell.index = indexPath.row
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
    
    let options: [(label: String, type: OptionsType, data: [Any])] = [
        ("Menu Clouds", .toggle, [Options.cloudsBool]),
        ("Menu Cloud Blur", .toggle, [Options.cloudBlurBool]),
        ("Menu Cloud Blur Amount", .slider, [Options.cloudBlurIntensity, 0, 50]),
        ("Shadows", .toggle, [Options.shadowsBool]),
        ("Shadow Blur", .toggle, [Options.shadowBlurBool]),
        ("Shadow Blur Amount", .slider, [Options.shadowBlurIntensity, 0, 50]),
        ("Ambience", .toggle, [Options.ambienceBool]),
        ("Ambience Blur", .toggle, [Options.ambienceBlurBool]),
        ("Ambience Blur Amount", .slider, [Options.ambienceBlurIntensity, 0, 20]),
        ("Ambience Particle Count", .slider, [Options.ambienceParticleCount, 128, 37268])
    ]
}

class ToggleCell: UITableViewCell {
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    var index: Int = 0
    @IBAction func valueChanged(_ sender: Any) {
        ((self.superview!.superview! as! GraphicsOptionsView).options[index].data[0] as! UnsafeMutablePointer<Bool>).pointee = toggle.isOn
    }
}

class SliderCell: UITableViewCell {
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var slider: UISlider!
    var index: Int = 0
    @IBAction func valueChanged(_ sender: Any) {
        ((self.superview!.superview! as! GraphicsOptionsView).options[index].data[0] as! UnsafeMutablePointer<Float>).pointee = slider.value
    }
}

class OkayCell: UITableViewCell {
    @IBAction func ok(_ sender: Any?) {
        // save options and go back to other view
        SaveData.saveOptions()
    }
}
