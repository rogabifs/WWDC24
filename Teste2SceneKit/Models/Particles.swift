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
    var stochasticAmplitude: Float
    var x: Float
    var y: Float
    static var z = Float(1.5)
    static var zisChange = false
    static let zDidChangeNotification = Notification.Name("zDidChange")
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.stochasticAmplitude = 0.0
        
        let geometry = SCNSphere(radius: 0.05)
        let materials = SCNMaterial()
        materials.diffuse.contents = UIColor.black
        materials.specular.contents = UIColor(white: 0.6, alpha: 0.4)
        self.node = SCNNode(geometry: geometry)
        self.node.geometry?.materials = [materials]
        self.node.position = SCNVector3(x: x, y: y, z: z)
        
      }
    
    func mov(chladni: ChladniFunc) -> SCNVector3 {
        if Particles.zisChange == true {
            node.position = SCNVector3(x: x, y: y, z: -(1.5 + Float(10) * Particles.z))
            Particles.zisChange = false
        } else {
            let eq = chladni.chladni(x: x, y: y, R: 0)
            stochasticAmplitude = abs(eq) * Constantes.v
            if stochasticAmplitude <= abs(chladni.minWalk) {
                stochasticAmplitude = abs(chladni.minWalk)
            }
            
            x += .random(in: -stochasticAmplitude...stochasticAmplitude)
            y += .random(in: -stochasticAmplitude...stochasticAmplitude)
        
            node.position = SCNVector3(x: x, y: y, z: -(1.5 + Float(10) * Particles.z))
        }
        
        return node.position
        
    }
    
}
