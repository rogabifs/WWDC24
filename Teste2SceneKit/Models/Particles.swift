//
//  Particles.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit

class Particles  {
    var node: SCNNode
    var x: Float
    var y: Float
    var stochasticAmplitude: Float
    
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
        self.stochasticAmplitude = 0.0
        
        let geometry = SCNSphere(radius: 0.005)
        let materials = SCNMaterial()
        materials.diffuse.contents = UIColor.systemRed
        materials.specular.contents = UIColor(white: 0.6, alpha: 0.4)
        self.node = SCNNode(geometry: geometry)
        self.node.geometry?.materials = [materials]
        self.node.position = SCNVector3(x: x, y: y, z: -1.5)
        
      }
    
    func mov(chladni: ChladniFunc) {
        let constantes =  Constantes(particles: chladni.particles, m: chladni.m, n: chladni.n, a: chladni.a, b: chladni.b, v: chladni.v)
        let eq = chladni.chladni(x: x, y: y, constantes: constantes)
        stochasticAmplitude = abs(eq) * chladni.v
        
        if stochasticAmplitude <= abs(chladni.minWalk) {
            stochasticAmplitude = abs(chladni.minWalk)
        }
        
        x += .random(in: -stochasticAmplitude...stochasticAmplitude)
        y += .random(in: -stochasticAmplitude...stochasticAmplitude)
        
        node.position = SCNVector3(x: x, y: y, z: 0)

    }
    
    func updateOffset() {
        if x<=0 {x = 0}
        if x>=1 {x = 1}
        if y<=0 {y = 0}
        if y>=1 {y = 1}
        
        // Terminar
        
    }
}
