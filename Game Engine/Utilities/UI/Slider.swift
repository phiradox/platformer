//
//  Slider.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/6/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

class Slider: Node, TouchMovementListener {
    var onRelease: () -> () = {() -> () in
        
    }
    var onMovement: (Point) -> () = {(location: Point) -> () in
        
    }
    
    func touched() {
        onRelease()
    }
    
    func touchMoved(to location: Point) {
        updateSlider(to: location)
        onMovement(location)
    }
    
    func updateSlider(to location: Point) {
        let screenPosition = self.screenPosition
        var locationInSelf = Point(x: location.x - screenPosition.x, y: 0)
        
        if locationInSelf.x < -self.size.width/2 {
            locationInSelf.x = -self.size.width/2
        }
        if locationInSelf.x > self.size.width/2 {
            locationInSelf.x = self.size.width/2
        }
        
        slider.position = locationInSelf
        
        let calculatedValue = (slider.position.x - self.size.width/2)/self.size.width*(upperBound-lowerBound)+upperBound
        value.pointee = calculatedValue
    }
    
    var slider: Node! = nil
    var bar: Node! = nil
    
    var value: UnsafeMutablePointer<Float>! = nil
    var lowerBound: Float! = nil
    var upperBound: Float! = nil
    
    init(in parent: Node, of value: UnsafeMutablePointer<Float>, boundedFrom lowerBound: Float, to upperBound: Float, sized size: Size, withSliderColored sliderColor: Color, andBarColored barColor: Color) {
        self.value = value
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        
        self.slider = Node()
        slider.geometry.dynamic = true
        slider.size = Size(width: size.height/3, height: size.height)
        slider.geometry.vertices = Rectangle(size: slider.size, color: sliderColor).toVertices()
        
        slider.position.x = (value.pointee - upperBound)*(size.width)/(upperBound-lowerBound)+(size.width/2)
        
        self.bar = Node()
        bar.size = Size(width: size.width, height: size.height/3)
        bar.geometry.vertices = Rectangle(size: bar.size, color: barColor).toVertices()
        super.init()
        parent.addChild(self)
        self.addChild(slider)
        self.addChild(bar)
        self.size = size
    }
    
}
