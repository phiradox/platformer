//
//  TextNode.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/1/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

class TextNode: Node {
    
    static var characters:[Character:[String]]=["A":["  X  "," X X ","X   X","XXXXX","X   X","X   X"],"a":[" XXX ","X   X","X  XX"," XX X"],"B":["XXXX ","X   X","XXXX ","X   X","X   X","XXXX "],"b":["X    ","X    ","XXXX ","X   X","X   X","XXXX "],"C":[" XXX ","X   X","X    ","X    ","X   X"," XXX "],"c":[" XXX","X   ","X   "," XXX"],"D":["XXX  ","X  X ","X   X","X   X","X  X ","XXX  "],"d":["    X","    X"," XXXX","X   X","X   X"," XXXX"],"E":["XXXXX","X    ","XXXX ","X    ","X    ","XXXXX"],"e":[" XX ","XXXX","X   "," XX "],"F":["XXXXX","X    ","XXXX ","X    ","X    ","X    "],"f":["   XX","  X  ","XXXXX","  X  ","  X  ","  X  "],"G":[" XXX ","X   X","X    ","X  XX","X   X"," XXX "],"g":[" XXXX","X   X"," XXXX","    X"," XXX "],"H":["X   X","X   X","XXXXX","X   X","X   X","X   X"],"h":["X    ","X    ","X XX ","XX  X","X   X","X   X"],"I":["XXXXX","  X  ","  X  ","  X  ","  X  ","XXXXX"],"i":[" X","  ","XX"," X"," X"],"J":["    X","    X","    X","X   X","X   X"," XXX "],"j":["   X","    ","   X","   X","X  X"," XX "],"K":["X   X","X  X ","X X  ","XX X ","X   X","X   X"],"k":["X    ","X  X ","X X  ","XXXX ","X   X","X   X"],"L":["X    ","X    ","X    ","X    ","X    ","XXXXX"],"l":["X","X","X","X","X","X"],"M":["X   X","XX XX","X X X","X   X","X   X","X   X"],"m":[" X X ","X X X","X   X","X   X"],"N":["X   X","XX  X","X X X","X X X","X  XX","X   X"],"n":[" XXX ","X   X","X   X","X   X"],"O":[" XXX ","X   X","X   X","X   X","X   X"," XXX "],"o":[" XX ","X  X","X  X"," XX "],"P":["XXXX ","X   X","X   X","XXXX ","X    ","X    "],"p":[" X ","X X","XX ","X   "],"Q":[" XXX ","X   X","X   X","X X X","X  X "," XX X"],"q":[" XX   ","X  X  ","X  X  "," XXX X","   XX ","   X  "],"R":["XXXX ","X   X","X   X","XXXX ","X   X","X   X"],"r":[" XX ","X  X","X    ","X    "],"S":[" XXX ","X   X"," XX  ","   X ","X   X"," XXX"],"s":["XX","X "," X","XX"],"T":["XXXXX","  X  ","  X  ","  X  ","  X  ","  X  "],"t":[" X "," X ","XXX"," X "," X ","  X"],"U":["X   X","X   X","X   X","X   X","X   X"," XXX "],"u":["X  X","X  X","X  X"," XX "],"V":["X   X","X   X","X   X"," X X "," X X ","  X  "],"v":["X   X"," X X "," X X ","  X  "],"W":["X   X","X   X","X X X","X X X"," X X "," X X "],"w":["X X X","X X X"," X X "," X X "],"X":["X   X"," X X ","  X  "," X X ","X   X","X   X"],"x":["     ","X  X"," XX "," XX ","X  X"],"Y":["X   X","X   X"," X X ","  X  ","  X  ","  X  "],"y":["X  X"," XXX","   X"," XX "],"Z":["XXXXX","   X ","  X  "," X   ","X    ","XXXXX"],"z":["XXXX","  X "," X  ","XXXX"]," ":["     "],".":["XX","XX"],"_":["XXXXXX"],"-":[" XXXX ","      ","      ","      ",],"(":["  X"," X ","X  ","X  "," X ","  X"],")":["X  "," X ","  X","  X"," X ","X  "],"?":[" XXX ","X   X","   X ","  X  ","     ","  X  "],"0":[" XXX ","X  XX","X X X","XX  X","X   X"," XXX "],"1":[" X ","XX "," X "," X "," X ","XXX"],"2":[" XXX ","X   X","   X ","  X  "," X   ","XXXXX"],"3":[" XXX ","X   X","   X ","    X","X   X"," XXX"],"4":["X  X "," X X "," X X ","XXXXX","   X ","   X "],"5":["XXXXX","X    ","XXXX ","    X","X   X"," XXX "],"6":["  X  "," X   ","XXXX ","X   X","X   X"," XXX "],"7":["XXXXX","    X","   X ","  X  "," X   ","X    "],"8":[" XXX ","X   X"," XXX ","X   X","X   X"," XXX "],"9":[" XXX ","X   X","X   X"," XXXX","   X ","  X  "],"*":[" X ","XXX"," X ","   "]]
    
    var tileSize: Float! = nil
    var text: String {
        didSet {
            compile()
        }
    }
    var block: Block! = nil
    
    init(of string: String, madeOf block: Block, sized size: Float, at position: Point) {
        tileSize = size/6
        block.size = Size(width: tileSize, height: tileSize)
        self.block = block
        text = string
        super.init()
        self.size.height = size
        self.position = position
        //self.geometry.dynamic = true
    }
    
    func compile() {
        var offset = Point(x: 0, y: 0)
        for char in text {
            if let charShape = TextNode.characters[char] {
                let charHeight = Float(charShape.count)*tileSize
                if charHeight > self.size.height {
                    self.size.height = charHeight
                }
                offset.y = charHeight/2
                offset.x += Float(charShape[0].count)*tileSize/2
                Rasterizer.rasterize(charShape, repeating: block, sized: tileSize, in: self, offset: offset)
                offset.x += Float(charShape[0].count)*tileSize/2 + tileSize
            }
        }
        offset.x -= tileSize
        self.size.width = offset.x
    }
}
