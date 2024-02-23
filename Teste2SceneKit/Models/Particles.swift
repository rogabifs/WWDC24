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
    var zAxis: Float
    static var z = Float(1.5)
    static var zisChange = false
    static let zDidChangeNotification = Notification.Name("zDidChange")
    var isSelected: Bool = false
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.zAxis = z
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
            print("m vale \(ChladniFunc.const_m)")
            print("n vale \(ChladniFunc.const_n)")
            let eq = chladni.chladni(x: x, y: y, R: 0)
//            let eq_1 = chladni.calculateValuesForParticles(xValues: [x], yValues: [y], R: 0)
            stochasticAmplitude = abs(eq) * Constantes.v
//           stochasticAmplitude = eq_1.reduce(0.0) { $0 + abs($1) } / Float(eq_1.count) * Constantes.v

            if stochasticAmplitude <= abs(chladni.minWalk) {
                stochasticAmplitude = abs(chladni.minWalk)
            }
            
            x += .random(in: -stochasticAmplitude...stochasticAmplitude)
            y += .random(in: -stochasticAmplitude...stochasticAmplitude)
        
            node.position = SCNVector3(x: x, y: y, z: -(1.5 + Float(10) * Particles.z))
        }
        
        return node.position
    }
    
    func calculateMovFromFrequency(chladni: ChladniFunc) -> SCNVector3 {
        if Particles.zisChange == true {
            node.position = SCNVector3(x: x, y: y, z: -(1.5 + Float(10) * Particles.z))
            Particles.zisChange = false
        } else {
            print(ToneGenerator.frequency)
//            let (m,n) = chladni.findMN(forW: ToneGenerator.frequency) ?? (Int(),Int())
//            print(m)
//            print(n)
//            ChladniFunc.const_m = Float(m)
//            ChladniFunc.const_n = Float(n)
            chladni.chladniAtribute(frequency: ToneGenerator.frequency)
//            print("m vale \(ChladniFunc.const_m)")
//            print("n vale \(ChladniFunc.const_n)")
            let result = chladni.chladni(x: x, y: y, R: 0)
            stochasticAmplitude = abs(result) * Constantes.v
            //           stochasticAmplitude = eq_1.reduce(0.0) { $0 + abs($1) } / Float(eq_1.count) * Constantes.v
            
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
