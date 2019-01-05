//
//  MenuViewController.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/25/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit
import Metal
import MetalKit
import AVKit

class MenuViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var customLevels: UIScrollView!
    @IBOutlet weak var playMenu: UIView!
    @IBOutlet weak var mainMenu: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var background: BackgroundView!
    @IBOutlet weak var optionsMenu: UIView!
    @IBOutlet weak var graphicsMenu: GraphicsOptionsView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SaveData.loadLevels()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        SaveData.loadLevels()
    }
    
    override func viewDidLayoutSubviews() {
        playMenu.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //customLevels.frame = CGRect(x: self.view.frame.width, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        optionsMenu.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height * 3)
        mainMenu.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        GlobalVars.currentViewController = self
        scrollView.delegate = self
    }
    
    /*func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = self.view.frame.width
        let cellHeight = self.view.frame.height
        var cellXIndex = floor(targetContentOffset.pointee.x + self.view.frame.width/2 / cellWidth)
        var cellYIndex = floor(targetContentOffset.pointee.y + self.view.frame.height/2 / cellHeight)
        
        
        targetContentOffset.pointee.x = cellXIndex * cellWidth
        targetContentOffset.pointee.y = cellYIndex * cellHeight
    }*/
    
    @IBAction func mainMenu(_ sender: Any) {
        mainMenu.becomeFirstResponder()
        scrollView.scrollRectToVisible(mainMenu.frame, animated: true)
    }
    
    @IBAction func play(_ sender: Any) {
        playMenu.becomeFirstResponder()
        scrollView.scrollRectToVisible(playMenu.frame, animated: true)
    }
    
    @IBAction func options(_ sender: Any) {
        print("options button pressed")
        optionsMenu.becomeFirstResponder()
        scrollView.scrollRectToVisible(optionsMenu.frame, animated: true)
    }
    
    @IBAction func customLevels(_ sender: Any) {
        customLevels.becomeFirstResponder()
        scrollView.scrollRectToVisible(customLevels.frame, animated: true)
    }
    
    @IBAction func graphics(_ sender: Any) {
        print("graphics button pressed")
        graphicsMenu.becomeFirstResponder()
        scrollView.scrollRectToVisible(graphicsMenu.frame, animated: true)
    }
    
}
