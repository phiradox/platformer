//
//  ScrollSubView.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/14/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

enum Directionality {
    case vertical, horizontal, both
}

class SKScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Vars
    
    weak var movingNode: Node? = nil {
        didSet {
            if let node = movingNode {
                changeNode(to: node)
            }
        }
    }
    weak var scene: Scene! = nil
    var directionality: Directionality! = nil
    
    @objc var cellSize: CGFloat = 0.0
    @objc var cellOffset: CGFloat = 0.0
    
    @objc var contentSnapping = false
    
    // MARK: Init
    
    init(in scene: Scene, of node: Node?, frame: CGRect, with directionality: Directionality) {
        super.init(frame: frame)
        delegate = self
        self.movingNode = node
        self.scene = scene
        self.frame = frame
        self.directionality = directionality
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    // MARK: Changing nodes...
    
    private func changeNode(to node: Node) {
        contentSize = CGSize(width: CGFloat(node.size.width), height: CGFloat(node.size.height))
    }
    
    // MARK: Scrolling
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if directionality == .horizontal || directionality == .both {
            movingNode?.position.x = -(Float)(scrollView.contentOffset.x)
        }
        if directionality == .vertical || directionality == .both {
            movingNode?.position.y = Float(scrollView.contentOffset.y)
        }
    }
    
    // MARK: Scroll Snapping
    
    @objc func enableContentSnapping(forCellSize size: CGFloat, withOffset offset: CGFloat) {
        self.cellSize = size
        self.cellOffset = offset
        self.contentSnapping = true
    }
    
    @objc func disableContentSnappe() {
        self.contentSnapping = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // round out which cell the target will reach and set it to snap to that one
        // get the cell index it will hit
        if self.contentSnapping {
            if directionality == .vertical {
                var targetOffset = targetContentOffset.pointee
                let currentIndex = CGFloat(floor(Double((contentOffset.y) / cellSize)))
                var targetIndex = CGFloat(floor(Double((targetOffset.y) / cellSize)))
                if currentIndex == targetIndex {
                    if velocity.y > 0.0 {
                        targetIndex += 1
                    } else {
                        targetIndex -= 1
                    }
                }
                targetOffset.y = targetIndex * cellSize
                targetContentOffset.pointee = targetOffset
            }
        }
        
    }
    
    // MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.touchesEnded(touches, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

