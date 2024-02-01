//
//  Constantes.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation

class Constantes {
    var particles: Int
    var m: Float
    var n: Float
    var a: Float
    var b: Float
    var v: Float
    let A: Float = 0.02
    let minWalk: Float = 0.002
    
    
    init(particles: Int, m: Float, n: Float, a: Float, b: Float, v: Float) {
        self.particles = particles
        self.m = 3.0
        self.n = 3.0
        self.a = 0.02
        self.b = 0.002
        self.v = 0.002
    }
}


