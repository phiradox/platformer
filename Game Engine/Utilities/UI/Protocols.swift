//
//  UI.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/6/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation

protocol Pressable {
    var onRelease: () -> () { get set }
    func touched ()
}

protocol TouchMovementListener: Pressable {
    var onMovement: (Point) -> () { get set }
    func touchMoved(to location: Point)
}
