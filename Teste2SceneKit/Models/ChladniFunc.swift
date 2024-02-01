//
//  Funcoes.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit

class ChladniFunc: Constantes {
    override init(particles: Int, m: Float, n: Float, a: Float, b: Float, v: Float) {
        super.init(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
        self.particles = particles
        self.m = m
        self.n = n
        self.a = a
        self.b = b
        self.v = v
    }
    
    func chladni(x:Float,y:Float,constantes: Constantes) -> Float {
        var const_a = constantes.a
        var const_b = constantes.b
        var const_m = constantes.m
        var const_n = constantes.n
        
        var sin_nx: Float = sin(.pi * const_n * x)
        var sin_my: Float = sin(.pi * const_m * y)
        var sin_mx: Float = sin(.pi * const_m * x)
        var sin_ny: Float = sin(.pi * const_n * y)
        
        var result =  const_a * sin_nx * sin_my + const_b * sin_mx * sin_ny
        
        return result
    }
}
