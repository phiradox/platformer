//
//  Matrix.swift
//  HelloMetal
//
//  Created by Ariston Kalpaxis on 12/29/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import Foundation

class Matrix4x4 {
    
    static func identity() -> [Float] {
        return [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        ]
    }
    
    static func multiply(_ matrix1: [Float], by matrix2: [Float]) -> [Float] {
        var matrix: [Float] = Array(repeating: Float(0), count: 16)
        for x in 0...16 {
            for y in 0...16 {
                let a = matrix1[0+4*y] * matrix2[0+x]
                let b = matrix1[1+4*y] * matrix2[4+x]
                let c = matrix1[2+4*y] * matrix2[8+x]
                let d = matrix1[3+4*y] * matrix2[12+x]
                matrix[x+4*y] = a + b + c + d
            }
        }
        
        return matrix
    }
    
    func translate(_ matrix: [Float], x: Float, y: Float, z: Float) -> [Float] {
        return Matrix4x4.multiply(matrix, by: [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            x, y, z, 1
        ])
    }
    
    func scale(_ matrix: [Float], x: Float, y: Float, z: Float) -> [Float] {
        return Matrix4x4.multiply(matrix, by: [
            x, 0, 0, 0,
            0, y, 0, 0,
            0, 0, z, 0,
            0, 0, 0, 1
        ])
    }
    
    func rotate(_ matrix: [Float], x: Float, y: Float, z: Float) -> [Float] {
        return Matrix4x4.multiply(matrix,
            by: Matrix4x4.multiply([
                    // y
                    1, 0, 0, 0,
                    0, cos(y), sin(y), 0,
                    0, -sin(y), cos(y), 0,
                    0, 0, 0, 1
                ],
                by: Matrix4x4.multiply([
                        // x
                        cos(y), 0, -sin(y), 0,
                        0, 1, 0, 0,
                        sin(y), 0, cos(y), 0,
                        0, 0, 0, 1
                    ],
                    by: [
                        // z
                        cos(z), sin(z), 0, 0,
                        -sin(z), cos(z), 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1
                    ])
                )
            )
    }
    
    static func numberOfElements() -> Int {
        return 16
    }
    
}
