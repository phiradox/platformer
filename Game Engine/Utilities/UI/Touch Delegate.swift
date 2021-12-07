//
//  Touch Delegate.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/7/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import UIKit

protocol TouchDelegate {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
}
